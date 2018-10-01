%%
clear;
close all;
clc;

global gverbose mdpverbose plot_traj_iter
gverbose = 1;
mdpverbose = 0;
plot_traj_iter = 1;
addpath(genpath(pwd))

%% Problem specification
pb_type = 1;
pb_spec;

%% Algorithm specification
alg_type = 'adal';
alg_spec;

%% Run solver
solver_opt_mdp;

%% MakeVideo
vfilename = 'makeplot/iter_ds4.avi';
video_trajiter;