#!/usr/bin/env python
"""This is a script that retains only the longest melody (assumed post-cleaning)
for each Cantus ID in a source. Ignores '-' in counting lengths.
"""

import argparse
import collections
import logging
import time

import csv

# import pandas as pd
# import volpiano     # Local relative import. Bad practice, but quick dirty solution for now.


def build_argument_parser():
    parser = argparse.ArgumentParser(description=__doc__, add_help=True,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('--input_csv', '-i', type=str, required=True,
                        help='Path to the CSV file with the Christmas chants to clean.')
    parser.add_argument('--output_csv', '-o', type=str, required=True,
                        help='Path to the output CSV file with the cleaned Christmas chants.')

    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Turn on INFO messages.')
    parser.add_argument('--debug', action='store_true',
                        help='Turn on DEBUG messages.')

    return parser


def compute_volpiano_length(volpiano_string):
    volpiano_no_gaps = volpiano_string.replace('-', '')
    return len(volpiano_no_gaps)


def main(args):
    logging.info('Starting main...')
    _start_time = time.process_time()

    # Load the given CSV file.
    with open(args.input_csv, 'r', newline='') as fh:
        csv_reader = csv.DictReader(fh)
        chants_csv = [row for row in csv_reader]

    # For each siglum, retain only the longest version for each Cantus ID
    siglum_melody_dicts_for_cids = collections.defaultdict(dict)
    for row in chants_csv:
        siglum = row['siglum']
        if siglum not in siglum_melody_dicts_for_cids:
            siglum_melody_dicts_for_cids[siglum] = dict()


        cantus_id = row['cantus_id']
        volpiano = row['volpiano']
        current_length = compute_volpiano_length(volpiano)

        current_longest_length = -1
        if cantus_id in siglum_melody_dicts_for_cids[siglum]:
            current_longest_row = siglum_melody_dicts_for_cids[siglum][cantus_id]
            current_longest_length = compute_volpiano_length(current_longest_row['volpiano'])

        if current_length > current_longest_length:
            siglum_melody_dicts_for_cids[siglum][cantus_id] = row

    # Collect all the retained rows.
    output_rows = []
    for siglum in siglum_melody_dicts_for_cids:
        for cantus_id in siglum_melody_dicts_for_cids[siglum]:
            output_rows.append(siglum_melody_dicts_for_cids[siglum][cantus_id])

    # Write them to output
    with open(args.output_csv, 'w') as fh:
        csv_writer = csv.DictWriter(fh, fieldnames=csv_reader.fieldnames)
        csv_writer.writeheader()
        for row in output_rows:
            csv_writer.writerow(row)

    _end_time = time.process_time()
    logging.info('scrape_cantus_db_sources.py done in {0:.3f} s'.format(_end_time - _start_time))


if __name__ == '__main__':
    parser = build_argument_parser()
    args = parser.parse_args()

    if args.verbose:
        logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)
    if args.debug:
        logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.DEBUG)

    main(args)
