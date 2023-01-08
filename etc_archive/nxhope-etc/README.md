## NOTES
### video driver:  
the video .ko module is being read from symbolic link at ``lib\modules\4.14.0-miyoo\kernel\drivers\video\fbdev\r61520fb.ko``
which is pointing to ``\mnt\kernel\r61520fb.ko``  

---
you can create such link with: ``ln -s source_file myfile``  
- _source_file_ - path to the existing file e.g. ``\mnt\kernel\r61520fb.ko``  
- _myfile_ - name of the symbolic link e.g. ``r61520fb.ko``