3D/ND spot detection

for ideal use case
1) calibreate camera and acquire pixel dependent {offset_i, gain_i, variance_i}.
2) capture an experimental image (ADU units)
3) transform image (ADU units) to electrons
4) add camera variance image (in electon units) to fulfill poisson approximation
5) apply stage one MLE

for just-get-it-done case (empiracly works well)
1) capture image
2) apply stage one MLE
