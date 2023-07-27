* **Description:**     
Program to calculate possible DDR output PLL registers.

* **source from:**  
``clock()`` function base of [FC100s_projects](  https://github.com/nminaylov/F1C100s_projects/blob/master/f1c100s/drivers/src/f1c100s_clock.c)

* **build instructions**   
```
g++ -o ddr_clock ddr_clock.cpp
```
add ``-DOC_TABLE`` (to print bitsets in table form)
add ``-DOC_CHOICES`` (to print valid decimal PLL output values)
add ``-static`` for static builds

* **usage:**  
run ``./ddr_clock.exe`` app in terminal
