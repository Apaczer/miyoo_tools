Use at will.

### For displaying all changes of specifc src file in directory type:

- log
```
git log --follow -- [FILE_PATH]
```
add `-p` opt in above git cmd to show patches also

- format-patch without path trace
```
git format-patch --root --relative=[DIR_PATH] -- [FILE_PATH]
```