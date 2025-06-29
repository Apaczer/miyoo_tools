### **Description:**     
Static build of RetroArch with fake-08 core compiled in as lib.a

### **Source from:**  
jtothebell's [fake-08](https://github.com/jtothebell/fake-08)

### **Build instructions**   
- apply libretro_fake_08 patch to fake-08 repo 
- build & copy output *.a core file to RetroArch repo topdir
- apply RA_fake_08 patch to retroarch repo
- build staticly linked `retroarch` with build-in core

### **Usage:**  
Content can only be load through CLI without any options, provide assets in /mnt/.retroarch
