# Team20 - RISC-V Lab 4
RISC-V CPU Project for Imperial EIE 2023/24

## Notes:

- Not sure if the PC is correct, it msut follow byte addressing and so i assume we must ignore the last 2 bits since each word address increments by a value of 4
, and so I only read the adress of the PC[31:2], I will change this if my interpretation of byte adressing is incorrect. So far it seems to work, check screenshots below.

![mem](/images/img1.png)
![trace1](/images/img2.png)
![trace2](/images/img3.png)