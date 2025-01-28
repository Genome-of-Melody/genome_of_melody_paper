#!/usr/bin/bash

cd ../data

for i in `ls *.fasta`; do
    sed -i 's/A-Gu : Ms 0807/A_Gu_Ms_0807/g' $i
    sed -i 's/CH-Cobodmer : C 0074/CH_Cobodmer_C_0074/g' $i
    sed -i 's/CH-ROM : Ms. liturg. FiD 5/CH_ROM_Ms_liturg_FiD_5/g' $i
    sed -i 's/D-B : Ms mus 40078/D_B_Ms_mus_40078/g' $i
    sed -i 's/D-HEu : Cod. Sal. X,007/D_HEu_Cod_Sal_X_007/g' $i
    sed -i 's/D-KNd : Ms 1001b/D_KNd_Ms_1001b/g' $i
    sed -i 's/D-LEu : Ms Thomas 391/D_LEu_Ms_Thomas_391/g' $i
    sed -i 's/F-CA : Ms 0061 (62)/F_CA_Ms_0061_62/g' $i
    sed -i 's/F-G : Ms 0084 (Ms. 395 Rés.)/F_G_Ms_0084_Ms_395_Res/g' $i
    sed -i 's/F-NS : Ms 0004/F_NS_Ms_0004/g' $i
    sed -i 's/F-Pa : Ms 0197/F_Pa_Ms_0197/g' $i
    sed -i 's/F-Pn : Ms Lat 00833/F_Pn_Ms_Lat_00833/g' $i
    sed -i 's/F-Pn : Ms Lat 00903/F_Pn_Ms_Lat_00903/g' $i
    sed -i 's/F-Pn : Ms Lat 17307/F_Pn_Ms_Lat_17307/g' $i
    sed -i 's/F-Pn : NAL 01235/F_Pn_NAL_01235/g' $i
    sed -i 's/F-Pn : NAL 01414/F_Pn_NAL_01414/g' $i
    sed -i 's/F-PR : Ms 0012/F_PR_Ms_0012/g' $i
    sed -i 's/F-SEm : Ms 018/F_SEm_Ms_018/g' $i
    sed -i 's/I-BGc : MA 150 (Psi III.8)/I_BGc_MA_150_Psi_III_8/g' $i
    sed -i 's/I-BGc : MA 239 (Gamma III.18)/I_BGc_MA_239_Gamma_III_18/g' $i
    sed -i 's/NL-Uu : Hs. 0415/NL_Uu_Hs_0415/g' $i
    sed -i 's/PL-Wn rps 12722 V/PL_Wn_rps_12722_V/g' $i
    sed -i 's/PL-WRu I F 414/PL_WRu_I_F_414/g' $i
    sed -i 's/PL-WRu I F 416/PL_WRu_I_F_416/g' $i
    sed -i 's/V-CVbav : Ross.0076/V_CVbav_Ross_0076/g' $i
    sed -i 's/V-CVbav : Vat.lat.05319/V_CVbav_Vat_lat_05319/g' $i
    sed -i 's/-//g' $i
done
