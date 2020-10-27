/* Author: Zheng Liu */
/* Purpose: Generate the dataset */



/* Read in the data from moodle */
data t_data_1;
  input n z;
  datalines;
  1  -2.401
  2  -.574
  3  .382
  4  -.535
  5  -1.639
  6  -.960
  7  -1.118
  8  -.719
  9  -1.236
 10  .117
 11  -.493
 12  -2.282
 13  -1.823
 14  .645
 15  -.179
 16  .589
 17  1.413
 18  .370
 19  .082
 20  -.531
 21  -1.891
 22  -.961
 23  -.865
 24  -.790
 25  -1.476
 26  -2.491
 27  -4.479
 28  -2.809
 29  -2.154
 30  -1.532
 31  -2.119
 32  -3.349
 33  -1.588
 34  .740
 35  .907
 36  1.540
 37  .557
 38  2.259
 39  2.622
 40  .701
 41  2.463
 42  2.714
 43  2.089
 44  3.750
 45  4.322
 46  3.186
 47  3.192
 48  2.939
 49  3.263
 50  3.279
 51  .295
 52  .227
 53  1.356
 54  1.912
 55  1.060
 56  .370
 57  -.195
 58  .340
 59  1.084
 60  1.237
 61  .610
 62  2.126
 63  3.960
 64  3.317
 65  2.167
 66  1.292
 67  .595
 68  .140
 69  -.082
 70  -.769
 71  .870
 72  1.551
 73  2.610
 74  2.193
 75  1.353
 76  -.600
 77  -.455
 78  .203
 79  1.472
 80  1.367
 81  1.875
 82  2.082
 83  1.604
 84  2.033 
 85  3.746
 86  2.954
 87  .676
 88  1.163
 89  1.368
 90  .343
 91  -.334
 92  1.041
 93  1.328
 94  1.325
 95  .968
 96  1.970
 97  2.296
 98  2.896
 99  1.918
100  1.569
;
run;

data t_data_2;
  input n z;
  datalines;
  1  -1.453
  2  .867
  3  .727
  4  -.765
  5  -1.317
  6  .024
  7  -.542
  8  -.048
  9  -.805
 10  .858
 11  -.563
 12  -1.986
 13  -.454
 14  1.738
 15  -.566
 16  .697
 17  1.060
 18  -.478
 19  -.140
 20  -.581
 21  -1.572
 22  .174
 23  -.289
 24  -.270
 25  -1.002
 26  -1.605
 27  -2.984
 28  -.122
 29  .469
 30  -.239
 31  -1.2
 32  -2.077
 33  .421
 34  1.693
 35  .463
 36  .996
 37  -.367
 38  1.925
 39  1.267
 40  -.872
 41  2.043
 42  1.236
 43  .461
 44  2.497
 45  2.072
 46  .593
 47  1.281
 48  1.023
 49  1.500
 50  1.321 
 51  -1.673
 52  0.050
 53  1.219
 54  1.098
 55  -.087
 56  -.266
 57  -.417
 58  .457
 59  .880
 60  .586
 61  -.132
 62  1.760
 63  2.684
 64  .941
 65  .177
 66  -.008
 67  -.180
 68  -.217
 69  -.165
 70  -.720
 71  1.332
 72  1.029
 73  1.679
 74  .627
 75  .038
 76  -1.412
 77  -.095
 78  .476
 79  1.350
 80  .484
 81  1.055
 82  .957
 83  .355
 84  1.071 
 85  2.526
 86  .707
 87  -1.096
 88  .757
 89  .670
 90  -.477
 91  -.540
 92  1.241
 93  .3704
 94  .528
 95  .173
 96  1.389
 97  1.115
 98  1.519
 99  .180
100  .419
;
run;