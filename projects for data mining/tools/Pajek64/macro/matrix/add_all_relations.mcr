NETBEGIN 2
CLUBEGIN 3
PERBEGIN 1
CLSBEGIN 1
HIEBEGIN 1
VECBEGIN 5
NETPARAM 1
CLUPARAM 2
VECPARAM 4

Msg Compute all kinship relations in given Ore graph

N 2 MULTEXTR 1 [1] (47956)
N 3 TRAN 2 (47956)
Msg Multiplying matrices
N 4 MULTIPLYNET 3 2 1 (47956)
N 2 DN  (47956)
N 3 DN  (47956)
Msg Extracting relation(s)
N 5 MULTEXTR 1 [2] (47956)
N 6 TRAN 5 (47956)
Msg Multiplying matrices
N 7 MULTIPLYNET 6 5 1 (47956)
N 5 DN  (47956)
N 6 DN  (47956)
N 8 CROSSINTERSECT 4 7 5 (47956)
N 4 DN  (47956)
N 7 DN  (47956)
N 8 DLOOPS 8 (47956)
N 9 REMARC 8 (47956)
C 3 BIN 2 [2] (47956)
V 5 MVEC 3 (47956)
N 10 PUTLOOPS 5 9 1 (47956)
N 9 DN  (47956)
Msg Multiplying matrices
N 11 MULTIPLYNET 10 8 1 (47956)
N 8 DN  (47956)
N 10 DN  (47956)
C 3 DC  (47956)
V 5 DV  (47956)
Msg Extracting relation(s)
N 13 MULTEXTR 1 [1,2] (47956)
N 14 FUSE 12 13 (47956)
Msg 14. Fusion of N12 and N13 (47956)
N 14 INFOLINES 14 999
N 14 RECODEN 14 0 "999" (47956)
N 12 DN  (47956)
N 13 DN  (47956)
Msg Multiplying matrices
N 15 MULTIPLYNET 11 14 1 (47956)
N 11 DN  (47956)
N 14 DN  (47956)
Msg Changing relation numbers and labels
N 15 CHRELNUMLAB 15 [1] 14 "Aunt"
N 16 FUSE 1 15 (47956)
N 16 NETNAME Relation AUNT added
N 15 DN  (47956)
N 1 DN  (47956)
Msg Extracting relation(s)
N 17 MULTEXTR 16 [1] (47956)
N 18 TRAN 17 (47956)
Msg Multiplying matrices
N 19 MULTIPLYNET 18 17 1 (47956)
N 17 DN  (47956)
N 18 DN  (47956)
Msg Extracting relation(s)
N 20 MULTEXTR 16 [2] (47956)
N 21 TRAN 20 (47956)
Msg Multiplying matrices
N 22 MULTIPLYNET 21 20 1 (47956)
N 20 DN  (47956)
N 21 DN  (47956)
N 23 CROSSINTERSECT 19 22 5 (47956)
N 19 DN  (47956)
N 22 DN  (47956)
N 23 DLOOPS 23 (47956)
N 24 REMARC 23 (47956)
C 4 BIN 2 [1] (47956)
V 6 MVEC 4 (47956)
N 25 PUTLOOPS 6 24 1 (47956)
N 24 DN  (47956)
Msg Multiplying matrices
N 26 MULTIPLYNET 25 23 1 (47956)
Msg Changing relation numbers and labels
N 27 CHRELNUMLAB 26 [1] 11 "Brother"
N 23 DN  (47956)
N 25 DN  (47956)
N 26 DN  (47956)
C 4 DC  (47956)
V 6 DV  (47956)
N 28 FUSE 16 27 (47956)
N 28 NETNAME Relation BROTHER added
N 27 DN  (47956)
N 16 DN  (47956)
Msg Extracting relation(s)
N 30 MULTEXTR 28 [1,2] (47956)
N 31 FUSE 29 30 (47956)
Msg Changing relation numbers and labels
N 31 CHRELNUMLAB 31 [1] 5 "Father"
Msg Changing relation numbers and labels
N 31 CHRELNUMLAB 31 [2] 5 "Child"
N 31 TRAN 31 (47956)
Msg 31. Transpose of N31 (47956)
N 31 INFOLINES 31 999
N 31 RECODEN 31 0 "999" (47956)
N 32 FUSE 28 31 (47956)
N 32 NETNAME Relation CHILD added
N 29 DN  (47956)
N 30 DN  (47956)
N 31 DN  (47956)
N 28 DN  (47956)
Msg Extracting relation(s)
N 34 MULTEXTR 32 [1,2] (47956)
N 35 FUSE 33 34 (47956)
Msg Changing relation numbers and labels
N 35 CHRELNUMLAB 35 [1] 7 "Daughter"
Msg Changing relation numbers and labels
N 35 CHRELNUMLAB 35 [2] 7 "Daughter"
N 35 TRAN 35 (47956)
Msg 35. Transpose of N35 (47956)
N 35 INFOLINES 35 999
N 35 RECODEN 35 0 "999" (47956)
N 33 DN  (47956)
N 34 DN  (47956)
N 36 REMARC 35 (47956)
C 5 BIN 2 [2] (47956)
V 7 MVEC 5 (47956)
N 37 PUTLOOPS 7 36 1 (47956)
Msg Multiplying matrices
N 38 MULTIPLYNET 37 35 1 (47956)
N 35 DN  (47956)
N 36 DN  (47956)
N 37 DN  (47956)
Msg Changing relation numbers and labels
N 38 CHRELNUMLAB 38 [1] 7 "Daughter"
N 39 FUSE 32 38 (47956)
N 39 NETNAME Relation DAUGHTER added
C 5 DC  (47956)
V 7 DV  (47956)
N 38 DN  (47956)
N 32 DN  (47956)
Msg Extracting relation(s)
N 40 MULTEXTR 39 [3] (47956)
N 41 REMEDG 40 (47956)
C 6 BIN 2 [1] (47956)
V 8 MVEC 6 (47956)
N 42 PUTLOOPS 8 41 1 (47956)
N 41 DN  (47956)
Msg Multiplying matrices
N 43 MULTIPLYNET 42 40 1 (47956)
Msg Changing relation numbers and labels
N 43 CHRELNUMLAB 43 [1] 8 "Husband"
N 40 DN  (47956)
N 42 DN  (47956)
N 44 FUSE 39 43 (47956)
N 44 NETNAME Relation HUSBAND added
N 43 DN  (47956)
C 6 DC  (47956)
V 8 DV  (47956)
N 39 DN  (47956)
Msg Extracting relation(s)
N 46 MULTEXTR 44 [1,2] (47956)
N 47 FUSE 45 46 (47956)
Msg Changing relation numbers and labels
N 47 CHRELNUMLAB 47 [1] 4 "Father"
Msg Changing relation numbers and labels
N 47 CHRELNUMLAB 47 [2] 4 "Parent"
Msg 47. Relation numbers [2] changed to 4 [Parent] in N47 (47956)
N 47 INFOLINES 47 999
N 47 RECODEN 47 0 "999" (47956)
N 48 FUSE 44 47 (47956)
N 48 NETNAME Relation PARENT added
N 45 DN  (47956)
N 46 DN  (47956)
N 47 DN  (47956)
N 44 DN  (47956)
Msg Extracting relation(s)
N 50 MULTEXTR 48 [1,2] (47956)
N 51 FUSE 49 50 (47956)
Msg Changing relation numbers and labels
N 51 CHRELNUMLAB 51 [1] 15 "SemiSibling"
Msg Changing relation numbers and labels
N 51 CHRELNUMLAB 51 [2] 15 "SemiSibling"
Msg 51. Relation numbers [2] changed to 15 [SemiSibling] in N51 (47956)
N 51 INFOLINES 51 999
N 51 RECODEN 51 0 "999" (47956)
N 49 DN  (47956)
N 50 DN  (47956)
N 52 TRAN 51 (47956)
Msg Multiplying matrices
N 53 MULTIPLYNET 52 51 1 (47956)
N 53 BATOEMIN 53 (47956)
N 53 DLOOPS 53 (47956)
Msg Changing relation numbers and labels
N 53 CHRELNUMLAB 53 [1] 15 "SemiSibling"
N 51 DN  (47956)
N 52 DN  (47956)
N 54 FUSE 48 53 (47956)
N 54 NETNAME Relation SEMISIBLING added
N 53 DN  (47956)
N 48 DN  (47956)
Msg Extracting relation(s)
N 55 MULTEXTR 54 [1] (47956)
N 56 TRAN 55 (47956)
Msg Multiplying matrices
N 57 MULTIPLYNET 56 55 1 (47956)
N 55 DN  (47956)
N 56 DN  (47956)
Msg Extracting relation(s)
N 58 MULTEXTR 54 [2] (47956)
N 59 TRAN 58 (47956)
Msg Multiplying matrices
N 60 MULTIPLYNET 59 58 1 (47956)
N 58 DN  (47956)
N 59 DN  (47956)
N 61 CROSSINTERSECT 57 60 5 (47956)
N 57 DN  (47956)
N 60 DN  (47956)
N 61 DLOOPS 61 (47956)
Msg Changing relation numbers and labels
N 61 CHRELNUMLAB 61 [1] 10 "Sibling"
N 61 BATOEMIN 61 (47956)
N 62 FUSE 54 61 (47956)
N 62 NETNAME Relation SIBLING added
N 61 DN  (47956)
N 54 DN  (47956)
Msg Extracting relation(s)
N 63 MULTEXTR 62 [1] (47956)
N 64 TRAN 63 (47956)
Msg Multiplying matrices
N 65 MULTIPLYNET 64 63 1 (47956)
N 63 DN  (47956)
N 64 DN  (47956)
Msg Extracting relation(s)
N 66 MULTEXTR 62 [2] (47956)
N 67 TRAN 66 (47956)
Msg Multiplying matrices
N 68 MULTIPLYNET 67 66 1 (47956)
N 66 DN  (47956)
N 67 DN  (47956)
N 69 CROSSINTERSECT 65 68 5 (47956)
N 65 DN  (47956)
N 68 DN  (47956)
N 69 DLOOPS 69 (47956)
N 70 REMARC 69 (47956)
C 7 BIN 2 [2] (47956)
V 9 MVEC 7 (47956)
N 71 PUTLOOPS 9 70 1 (47956)
N 70 DN  (47956)
Msg Multiplying matrices
N 72 MULTIPLYNET 71 69 1 (47956)
Msg Changing relation numbers and labels
N 73 CHRELNUMLAB 72 [1] 12 "Sister"
N 69 DN  (47956)
N 71 DN  (47956)
N 72 DN  (47956)
C 7 DC  (47956)
V 9 DV  (47956)
N 74 FUSE 62 73 (47956)
N 74 NETNAME Relation SISTER added
N 73 DN  (47956)
N 62 DN  (47956)
Msg Extracting relation(s)
N 76 MULTEXTR 74 [1,2] (47956)
N 77 FUSE 75 76 (47956)
Msg Changing relation numbers and labels
N 77 CHRELNUMLAB 77 [1] 6 "Son"
Msg Changing relation numbers and labels
N 77 CHRELNUMLAB 77 [2] 6 "Son"
N 77 TRAN 77 (47956)
Msg 77. Transpose of N77 (47956)
N 77 INFOLINES 77 999
N 77 RECODEN 77 0 "999" (47956)
N 75 DN  (47956)
N 76 DN  (47956)
N 78 REMARC 77 (47956)
C 8 BIN 2 [1] (47956)
V 10 MVEC 8 (47956)
N 79 PUTLOOPS 10 78 1 (47956)
Msg Multiplying matrices
N 80 MULTIPLYNET 79 77 1 (47956)
N 77 DN  (47956)
N 78 DN  (47956)
N 79 DN  (47956)
Msg Changing relation numbers and labels
N 80 CHRELNUMLAB 80 [1] 6 "Son"
N 81 FUSE 74 80 (47956)
C 8 DC  (47956)
V 10 DV  (47956)
N 80 DN  (47956)
N 81 NETNAME Relation SON added
N 74 DN  (47956)
Msg Extracting relation(s)
N 82 MULTEXTR 81 [1] (47956)
N 83 TRAN 82 (47956)
Msg Multiplying matrices
N 84 MULTIPLYNET 83 82 1 (47956)
N 82 DN  (47956)
N 83 DN  (47956)
Msg Extracting relation(s)
N 85 MULTEXTR 81 [2] (47956)
N 86 TRAN 85 (47956)
Msg Multiplying matrices
N 87 MULTIPLYNET 86 85 1 (47956)
N 85 DN  (47956)
N 86 DN  (47956)
N 88 CROSSINTERSECT 84 87 5 (47956)
N 84 DN  (47956)
N 87 DN  (47956)
N 88 DLOOPS 88 (47956)
N 89 REMARC 88 (47956)
C 9 BIN 2 [1] (47956)
V 11 MVEC 9 (47956)
N 90 PUTLOOPS 11 89 1 (47956)
N 89 DN  (47956)
Msg Multiplying matrices
N 91 MULTIPLYNET 90 88 1 (47956)
N 88 DN  (47956)
N 90 DN  (47956)
C 9 DC  (47956)
V 11 DV  (47956)
Msg Extracting relation(s)
N 93 MULTEXTR 81 [1,2] (47956)
N 94 FUSE 92 93 (47956)
Msg 94. Fusion of N92 and N93 (47956)
N 94 INFOLINES 94 999
N 94 RECODEN 94 0 "999" (47956)
N 92 DN  (47956)
N 93 DN  (47956)
Msg Multiplying matrices
N 95 MULTIPLYNET 91 94 1 (47956)
N 91 DN  (47956)
N 94 DN  (47956)
Msg Changing relation numbers and labels
N 95 CHRELNUMLAB 95 [1] 13 "Uncle"
N 96 FUSE 81 95 (47956)
N 96 NETNAME Relation UNCLE added
N 95 DN  (47956)
N 81 DN  (47956)
Msg Extracting relation(s)
N 97 MULTEXTR 96 [3] (47956)
N 98 REMEDG 97 (47956)
C 10 BIN 2 [2] (47956)
V 12 MVEC 10 (47956)
N 99 PUTLOOPS 12 98 1 (47956)
N 98 DN  (47956)
Msg Multiplying matrices
N 100 MULTIPLYNET 99 97 1 (47956)
Msg Changing relation numbers and labels
N 100 CHRELNUMLAB 100 [1] 9 "Wife"
N 97 DN  (47956)
N 99 DN  (47956)
N 101 FUSE 96 100 (47956)
N 101 NETNAME All relations added
N 100 DN  (47956)
C 10 DC  (47956)
V 12 DV  (47956)
N 96 DN  (47956)
Msg 101. Relation WIFE added (47956)

