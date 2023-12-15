LI a0, 0
LI a2, 3
LI a3, 4
ADD a0, a3, a2

LI a0, 0
LI a2, 3
LI a3, -1
ADD a0, a3, a2

LI a0, 0
LI a2, 3
LI a3, 4
SUB a0, a3, a2

LI a0, 0
LI a2, 3
LI a3, -4
SUB a0, a3, a2

LI a0, 0
LI a2, 10
LI a3, 9
SLT a0, a3, a2

LI a0, 0
LI a2, 10
LI a3, -1
SLT a0, a3, a2

LI a0, 0
LI a3, 9
SLTI a0, a3, 10

LI a0, 0
LI a3, -1
SLTI a0, a3, 10

LI a0, 0
LI a2, -1
LI a3, 9
SLTU a0, a3, a2

LI a0, 0
LI a3, 9
SLTIU a0, a3, -1


LI a0, 0
LI a2, 5
LI a3, 3
AND a0, a2, a3 

LI a0, 0
LI a2, 5
LI a3, 3
OR a0, a2, a3


LI a0, 0
LI a2, 5
LI a3, 3
XOR a0, a2, a3

LI a0, 0
LI a2, 5
AND a0, a2, 3

LI a0, 0
LI a2, 5
OR a0, a2, 3

LI a0, 0
LI a2, 5
XOR a0, a2, 3

LI a0, 0
LI a3, 1
LI a2, 2
SLL a0, a2, a3

LI a0, 0
LI a3, 4
LI a2, -1
SRL a0, a2, a3
 
LI a0, 0
LI a3, 4
LI a2, -1
SRA a0, a2, a3

LI a0, 0
LI a2, 2
SLL a0, a2, 1

LI a0, 0
LI a2, -1
SRL a0, a2, 4

LI a0, 0
LI a2, -1
SRA a0, a2, 4

LI a0, 0
LUI a0, 1
