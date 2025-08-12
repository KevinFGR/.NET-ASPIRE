var builder = DistributedApplication.CreateBuilder(args);

string imageName = "kevinfgr/mdt-api";

builder.AddContainer("mdt-api", imageName).WithHttpEndpoint(targetPort: 80).WithEndpoint("http", x => x.Port = 5000);
builder.AddContainer("test-api", "kevinfgr/test-api").WithHttpEndpoint(targetPort: 80).WithEndpoint("http", x => x.Port = 5001);
builder.AddContainer("test-nagular", "kevinfgr/test-angular").WithHttpEndpoint(targetPort: 80).WithEndpoint("http", x => x.Port = 4200);

builder.Build().Run();