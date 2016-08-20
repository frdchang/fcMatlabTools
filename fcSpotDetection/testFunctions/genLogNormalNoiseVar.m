function cameraNoiseVar = genLogNormalNoiseVar(sizes,varargin)
%GENLOGNORMALNOISEVAR will generate scmos noise from an empiricle
%distriubtion measured from our camera.

%--parameters--------------------------------------------------------------
params.extrudeInZ     = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


% these are empiracal histogram values of read noise rms at slow scan mode of
% our scmos camera
edges = [1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4 4.05 4.1 4.15 4.2 4.25 4.3 4.35 4.4 4.45 4.5 4.55 4.6 4.65 4.7 4.75 4.8 4.85 4.9 4.95 5 5.05 5.1 5.15 5.2 5.25 5.3 5.35 5.4 5.45 5.5 5.55 5.6 5.65 5.7 5.75 5.8 5.85 5.9 5.95 6 6.05 6.1 6.15 6.2 6.25 6.3 6.35 6.4 6.45 6.5 6.55 6.6 6.65 6.7 6.75 6.8 6.85 6.9 6.95 7 7.05 7.1 7.15 7.2 7.25 7.3 7.35 7.4 7.45 7.5 7.55 7.6 7.65 7.7 7.75 7.8 7.85 7.9 7.95 8 8.05 8.1 8.15 8.2 8.25 8.3 8.35 8.4 8.45 8.5 8.55 8.6 8.65 8.7 8.75 8.8 8.85 8.9 8.95 9 9.05 9.1 9.15 9.2 9.25 9.3 9.35 9.4 9.45 9.5 9.55 9.6 9.65 9.7 9.75 9.8 9.85 9.9 9.95 10 10.05 10.1 10.15 10.2 10.25 10.3 10.35 10.4 10.45 10.5 10.55 10.6 10.65 10.7 10.75 10.8 10.85 10.9 10.95 11 11.05 11.1 11.15 11.2 11.25 11.3 11.35 11.4 11.45 11.5 11.55 11.6 11.65 11.7 11.75 11.8 11.85 11.9 11.95 12 12.05 12.1 12.15 12.2 12.25 12.3 12.35 12.4 12.45 12.5 12.55 12.6 12.65 12.7 12.75 12.8 12.85 12.9 12.95 13 13.05 13.1 13.15 13.2 13.25 13.3 13.35 13.4 13.45 13.5 13.55 13.6 13.65 13.7 13.75 13.8 13.85 13.9 13.95 14 14.05 14.1 14.15 14.2 14.25 14.3 14.35 14.4 14.45 14.5 14.55 14.6 14.65 14.7 14.75 14.8 14.85 14.9 14.95 15 15.05 15.1 15.15 15.2 15.25 15.3 15.35 15.4 15.45 15.5 15.55 15.6 15.65 15.7 15.75 15.8 15.85 15.9 15.95 16 16.05 16.1 16.15 16.2 16.25 16.3 16.35 16.4 16.45 16.5 16.55 16.6 16.65 16.7 16.75 16.8 16.85 16.9 16.95 17 17.05 17.1 17.15 17.2 17.25 17.3 17.35 17.4 17.45 17.5 17.55 17.6 17.65 17.7 17.75 17.8 17.85 17.9 17.95 18 18.05 18.1 18.15 18.2 18.25 18.3 18.35 18.4 18.45 18.5 18.55 18.6 18.65 18.7 18.75 18.8 18.85 18.9 18.95 19 19.05 19.1 19.15 19.2 19.25 19.3 19.35 19.4 19.45 19.5 19.55 19.6 19.65 19.7 19.75 19.8 19.85 19.9 19.95 20 20.05 20.1 20.15 20.2 20.25 20.3 20.35 20.4 20.45 20.5 20.55 20.6 20.65 20.7 20.75 20.8 20.85 20.9 20.95 21 21.05 21.1 21.15 21.2 21.25 21.3 21.35 21.4 21.45 21.5 21.55 21.6 21.65 21.7 21.75 21.8 21.85 21.9 21.95 22 22.05 22.1 22.15 22.2 22.25 22.3 22.35 22.4 22.45 22.5 22.55 22.6 22.65 22.7 22.75 22.8 22.85 22.9 22.95 23 23.05 23.1 23.15 23.2 23.25 23.3 23.35 23.4 23.45 23.5 23.55 23.6 23.65 23.7 23.75 23.8 23.85 23.9 23.95 24 24.05 24.1 24.15 24.2 24.25 24.3 24.35 24.4 24.45 24.5 24.55 24.6 24.65 24.7 24.75 24.8 24.85 24.9 24.95 25 25.05 25.1 25.15 25.2 25.25 25.3 25.35 25.4 25.45 25.5 25.55 25.6 25.65 25.7 25.75 25.8 25.85 25.9 25.95 26 26.05 26.1 26.15 26.2 26.25 26.3 26.35 26.4 26.45 26.5 26.55 26.6 26.65 26.7 26.75 26.8 26.85 26.9 26.95 27 27.05 27.1 27.15 27.2 27.25 27.3 27.35 27.4 27.45 27.5 27.55 27.6 27.65 27.7 27.75 27.8 27.85 27.9 27.95 28 28.05 28.1 28.15 28.2 28.25 28.3 28.35 28.4 28.45 28.5 28.55 28.6 28.65 28.7 28.75 28.8 28.85 28.9 28.95 29 29.05 29.1 29.15 29.2 29.25 29.3 29.35 29.4 29.45 29.5 29.55 29.6 29.65 29.7 29.75 29.8 29.85 29.9 29.95 30 30.05 30.1 30.15 30.2 30.25 30.3 30.35 30.4 30.45 30.5 30.55 30.6 30.65 30.7 30.75 30.8 30.85 30.9 30.95 31 31.05 31.1 31.15 31.2 31.25 31.3 31.35 31.4 31.45 31.5 31.55 31.6 31.65 31.7 31.75 31.8 31.85 31.9 31.95 32 32.05 32.1 32.15 32.2 32.25 32.3 32.35 32.4 32.45 32.5 32.55 32.6 32.65 32.7 32.75 32.8 32.85 32.9 32.95 33 33.05 33.1 33.15 33.2 33.25 33.3 33.35 33.4 33.45 33.5 33.55 33.6 33.65 33.7 33.75 33.8 33.85 33.9 33.95 34 34.05 34.1 34.15 34.2 34.25 34.3 34.35 34.4 34.45 34.5 34.55 34.6 34.65 34.7 34.75 34.8 34.85 34.9 34.95 35 35.05 35.1 35.15 35.2 35.25 35.3 35.35 35.4 35.45 35.5 35.55 35.6 35.65 35.7 35.75 35.8 35.85 35.9 35.95 36 36.05 36.1 36.15 36.2 36.25 36.3 36.35 36.4 36.45 36.5 36.55 36.6 36.65 36.7 36.75 36.8 36.85 36.9 36.95 37 37.05 37.1 37.15 37.2 37.25 37.3 37.35 37.4 37.45 37.5 37.55 37.6 37.65 37.7 37.75 37.8 37.85 37.9 37.95 38 38.05 38.1 38.15 38.2 38.25 38.3 38.35 38.4 38.45 38.5 38.55 38.6 38.65 38.7 38.75 38.8 38.85 38.9 38.95 39 39.05 39.1 39.15 39.2 39.25 39.3 39.35 39.4 39.45 39.5 39.55 39.6 39.65 39.7 39.75 39.8 39.85 39.9 39.95 40 40.05 40.1 40.15 40.2 40.25 40.3 40.35 40.4 40.45 40.5 40.55 40.6 40.65 40.7 40.75 40.8 40.85 40.9 40.95 41 41.05 41.1 41.15 41.2 41.25 41.3 41.35 41.4];
values = [2 39 690 5688 17836 30318 43406 65293 83256 90549 78901 64672 54763 46846 39920 33095 27507 22619 19149 16627 14470 12809 11460 10447 9542 8772 8305 7732 7086 6598 6006 5637 5124 4666 4537 4185 3880 3674 3400 3308 3058 2920 2853 2680 2582 2404 2384 2216 2221 2049 2010 2024 1893 1936 1838 1688 1784 1653 1550 1501 1534 1484 1405 1413 1325 1316 1241 1317 1237 1210 1226 1165 1093 1070 1104 1062 1034 1055 1018 994 927 929 925 913 859 783 876 831 847 829 804 792 709 766 729 801 724 717 671 645 676 680 707 591 631 572 624 548 562 553 575 582 580 515 515 486 502 492 476 468 441 449 436 452 429 418 428 442 359 403 409 385 409 361 406 412 358 364 390 384 356 348 320 334 321 325 297 327 306 312 303 290 289 273 283 272 299 280 262 268 261 267 251 232 237 245 229 226 211 215 242 211 239 229 215 206 206 196 193 199 188 184 178 180 174 191 191 183 197 133 169 148 162 160 164 133 150 133 154 136 163 145 138 150 117 146 134 146 138 145 123 118 144 112 108 132 105 134 100 109 99 99 112 103 95 104 101 96 81 81 91 84 100 111 85 78 85 72 87 84 83 83 77 54 73 82 71 73 60 80 65 79 62 68 61 52 57 53 55 65 56 70 49 53 51 45 68 64 62 52 52 41 57 42 63 40 52 43 48 39 39 45 63 28 31 45 38 46 51 33 35 45 32 42 43 45 34 50 41 34 30 32 31 35 47 28 25 29 28 28 31 39 26 27 27 36 35 22 36 32 21 25 19 27 29 21 21 30 24 29 21 16 14 14 24 21 18 26 14 29 14 16 22 24 13 19 22 18 9 25 23 9 11 13 22 15 16 12 13 16 16 10 21 8 13 20 17 10 12 12 10 18 17 13 5 10 9 18 11 8 14 10 7 17 7 10 8 10 14 6 9 10 10 9 3 14 9 3 15 5 6 10 6 7 7 7 1 5 10 9 7 8 7 11 8 7 4 6 6 7 5 5 8 8 6 5 6 11 6 6 3 7 5 7 7 8 4 5 5 5 6 8 2 11 6 6 5 3 7 4 5 9 8 4 3 6 3 3 4 2 2 6 1 9 1 8 2 6 3 13 2 5 10 2 4 2 1 2 5 3 3 3 2 3 2 3 3 5 0 5 3 6 6 1 3 2 5 3 5 3 2 1 1 2 5 4 2 3 0 2 5 0 1 1 1 0 0 1 5 3 2 3 0 0 2 2 0 3 1 0 0 1 1 1 2 1 3 3 2 1 2 1 0 1 2 2 1 1 0 0 1 2 1 1 1 1 0 0 1 1 2 1 2 1 2 2 2 2 3 0 1 0 1 1 0 2 0 1 1 1 1 0 0 3 0 0 0 1 1 1 1 1 2 1 3 0 0 1 0 0 0 0 2 1 1 0 0 0 1 0 2 2 1 1 0 1 1 0 1 0 1 1 0 3 0 1 1 0 0 1 1 1 0 0 1 0 1 0 0 0 0 0 0 0 1 1 1 2 1 0 0 0 2 0 0 0 0 1 0 0 0 0 1 1 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 1 0 2 1 0 0 1 0 1 2 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1];

if isscalar(sizes)
    samples = sampleFromEmpiricalDistribution(values,edges,sizes);
    cameraNoiseVar = samples.^2;
else
    % extrude the third dimension if provided
    samples = sampleFromEmpiricalDistribution(values,edges,prod(sizes(1:2)));
    samples = samples.^2;
    cameraNoiseVar = reshape(samples,sizes(1:2));
    if numel(sizes) == 3 && params.extrudeInZ
        cameraNoiseVar = repmat(cameraNoiseVar,[1 1 sizes(3)]);
    elseif numel(sizes) == 3 && ~params.extrudeInZ
        samples = sampleFromEmpiricalDistribution(values,edges,prod(sizes));
        samples = samples.^2;
        cameraNoiseVar = reshape(samples,sizes);
    end
end


