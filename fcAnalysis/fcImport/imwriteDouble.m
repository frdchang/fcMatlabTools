function imwriteDouble(filename,data)
% imwriteDouble(filename,data) saves floating point data in tiff image
n=ndims(data);
t=Tiff(filename,'w'); 
tagstruct.ImageLength = size(data,1);
tagstruct.ImageWidth = size(data,2);
tagstruct.BitsPerSample = 64;
if n==2
   tagstruct.SamplesPerPixel = 1;
   tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
elseif n == 3
   tagstruct.SamplesPerPixel = 3;
   tagstruct.Photometric = Tiff.Photometric.RGB;
else
   error('Image must have 2 or 3 dimensions');
end
tagstruct.Compression=Tiff.Compression.None;
tagstruct.SampleFormat=Tiff.SampleFormat.IEEEFP;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
t.setTag(tagstruct); 
t.write(data);
t.close();
end