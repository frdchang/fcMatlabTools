peaks = {[2 1 2 4 5 0;
          0 0 1 2 3 0;
          5 4 1 2 3 0;
          11 11 1 2 3 0;
          20 22 1 2 3 0;
          1 1 1 2 3 0],...
          [6 7 2 2 3 0;
          3 1 5 4 5 0;
          2 1 3 2 3 0;
          9 10 1 2 3 0;
          20 21 1 2 3 0],...
          [5 8 1 2 3 0;
          3 2 3 2 3 0;
          10 10 1 2 3 0;
          20 22 1 2 3 0],...
           [0 0 1 2 3 0;
          6 7 1 2 3 0;
          12 10 5 2 3 0]};
     
      
tic;tests1 = link_trajectories3D(peaks,10);toc

tracks = extractTrajs(tests1);
tic;test2= link_trajectories3D_mex(peaks,10);toc