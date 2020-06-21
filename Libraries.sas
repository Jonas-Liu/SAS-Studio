%let p_git = /folders/myfolders/GitHub/SAS-Studio;
%let p_data = &p_git./Data/;


libname GIT "&p_git";
libname DATA "&p_data";

quit;