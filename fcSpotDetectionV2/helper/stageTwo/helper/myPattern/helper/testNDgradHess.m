data = rand(10,10,10);
domains = genMeshFromData(data);

[a,b] = NDgradientAndHessian(data,domains);