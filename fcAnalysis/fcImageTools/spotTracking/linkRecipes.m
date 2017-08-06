peaks = {[0 0 1 2 3 0;
          5 5 1 2 3 0;
          10 10 1 2 3 0;
          20 20 1 2 3 0],...
          [5 7 1 2 3 0;
          1 1 3 2 3 0;
          9 10 1 2 3 0;
          20 21 1 2 3 0],...
          [0 0 1 2 3 0;
          5 7 1 2 3 0;
          12 10 5 2 3 0;
          15 20 10 2 3 0]};
      
      
tic;link_trajectories3D(peaks,10);toc
tic;link_trajectories3D_mex(peaks,10);toc