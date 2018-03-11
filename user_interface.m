function [happy_folder,unhappy_folder] = user_interface
happy_folder = uigetdir('','Select happy folder');
unhappy_folder = uigetdir('','Select unhappy folder');
if happy_folder ~= 0
    happy_folder = strcat(happy_folder,'\');
end
if unhappy_folder ~= 0
    unhappy_folder = strcat(unhappy_folder,'\');
end