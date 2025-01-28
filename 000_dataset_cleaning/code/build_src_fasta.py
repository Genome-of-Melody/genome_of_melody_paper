#!/usr/bin/env python
"""This is a script that processes the cleaned Christmas dataset from CantusCorpus CSV
into FASTA files that can then directly serve as inputs to MSA and subsequente phylogeny
building.

If multiple versions of the same Cantus ID are found in one source, the longest melody
is used. This is for technical reasons -- the alignment cannot deal with uncertain position
values.
"""

import argparse
import logging
import os
import time

import csv


# These defaults are used for the Genome of Melody paper.
DEFAULT_CANTUS_IDS =  ['g00670',  'g00771',  'g00776',  'g00789',  'g00793',  'g00331',  'g00625', 'g00631',
                       'g00640',  'g00648',  'g00662',  'g00675',  'g00728',  'g00733',  'g00742', 'g00768',
                       'g00783',  'g00785',  'g00800',  'g01178']
DEFAULT_FASTA_NAMES = ['audivit', 'verbame', 'laetare', 'dumsanc', 'meditat', 'confess', 'adorate', 'circumd',
                       'exsurge', 'estomih', 'miserer', 'invocab', 'redimem', 'tibidix', 'lexdomi', 'facmecu',
                       'deusinn', 'exaudid', 'judicam', 'dumclam']
DEFAULT_SOURCE_SELECTION = ['A-Gu : Ms 0807', 'CH-ROM : Ms. liturg. FiD 5',
                            'D-B : Ms mus 40078', 'D-HEu : Cod. Sal. X,007', 'D-KNd : Ms 1001b', 'D-LEu : Ms Thomas 391',
                            'F-CA : Ms 0061 (62)', 'F-G : Ms 0084 (Ms. 395 Rés.)', 'F-NS : Ms 0004', 'F-Pa : Ms 0197',
                            'F-Pn : Ms Lat 00833', 'F-Pn : Ms Lat 17307', 'F-Pn : NAL 01235',
                            'F-Pn : NAL 01414', 'F-PR : Ms 0012', 'F-SEm : Ms 018', 'I-BGc : MA 150 (Psi III.8)',
                            'I-BGc : MA 239 (Gamma III.18)', 'NL-Uu : Hs. 0415', 'PL-Wn rps 12722 V', 'PL-WRu I F 414',
                            'PL-WRu I F 416', 'V-CVbav : Ross.0076']


def build_argument_parser():
    parser = argparse.ArgumentParser(description=__doc__, add_help=True,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('--input_csv', '-i', action='store', required=True,
                        help='Input Christmas dataset cantuscorpus-style CSV. Should at this point'
                             ' contain melodies that are sufficiently cleaned so that they can directly'
                             ' be used in the FASTA files (the output of running clean_christmas.py).')
    parser.add_argument('--output_directory', action='store', required=True,
                        help='Outputs the FASTA files -- one for each specified Cantus ID.')
    parser.add_argument('--cantus_ids', action='store', nargs='+',
                        default=DEFAULT_CANTUS_IDS,
                        help='List of Cantus IDs for which to build the FASTA files.')
    parser.add_argument('--siglas', action='store', nargs='+',
                        default=DEFAULT_SOURCE_SELECTION,
                        help='Only use melodies from this selection of sources.')
    parser.add_argument('--fasta_names', action='store', nargs='+',
                        default=DEFAULT_FASTA_NAMES,
                        help='List of names for the files for the individual Cantus IDs. Must have'
                             ' the same length as the --cantus_ids array.')

    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Turn on INFO messages.')
    parser.add_argument('--debug', action='store_true',
                        help='Turn on DEBUG messages.')

    return parser


def main(args):
    logging.info('Starting main...')
    _start_time = time.process_time()

    # Load the given CSV file.
    with open(args.input_csv, 'r', newline='') as fh:
        csv_reader = csv.DictReader(fh)
        christmas_csv = [row for row in csv_reader]

    siglum_melody_dicts_for_cids = dict()
    for cid in args.cantus_ids:
        siglum_melody_dicts_for_cids[cid] = dict()

    for row in christmas_csv:
        siglum = row['siglum']
        melody = row['volpiano']
        cid = row['cantus_id']
        if cid in siglum_melody_dicts_for_cids and siglum in args.siglas:
            _melody_dict = siglum_melody_dicts_for_cids[cid]
            # Have to keep only the longest melody for the given CID from each source.
            if siglum not in _melody_dict:
                _melody_dict[siglum] = []
            _melody_dict[siglum].append(melody)
            # else:
            #     _best_length = len(_melody_dict[siglum])
            #     _current_length = len(melody)
            #     if _current_length > _best_length:
            #         _melody_dict[siglum] = melody

    if not os.path.isdir(args.output_directory):
        logging.warning('Output directory does not exist. Creating: {}'.format(args.output_directory))
        os.makedirs(args.output_directory)

    cid_to_fasta_name_dict = {cid: name for cid, name in zip(args.cantus_ids, args.fasta_names)}
    for cid in siglum_melody_dicts_for_cids.keys():
        output_basename = cid_to_fasta_name_dict[cid] + '_src.fasta'
        output_file = os.path.join(args.output_directory, output_basename)
        with open(output_file, 'w') as output_fh:
            current_cid_melody_dict = siglum_melody_dicts_for_cids[cid]
            for siglum, melodies in sorted(current_cid_melody_dict.items()):
                for melody in melodies:
                    output_fh.write('> {}\n'.format(siglum))
                    output_fh.write('{}\n'.format(melody))

    _end_time = time.process_time()
    logging.info('build_src_fasta.py done in {0:.3f} s'.format(_end_time - _start_time))


if __name__ == '__main__':
    parser = build_argument_parser()
    args = parser.parse_args()

    if args.verbose:
        logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)
    if args.debug:
        logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.DEBUG)

    main(args)
