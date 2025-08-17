var builder = DistributedApplication.CreateBuilder(args);

string imageName = "kevinfgr/mdt-api";

builder.AddContainer("mdt-api", imageName).WithHttpEndpoint(targetPort: 80).WithEndpoint("http", x => x.Port = 5000);
builder.AddContainer("test-api", "kevinfgr/test-api").WithHttpEndpoint(targetPort: 80).WithEndpoint("http", x => x.Port = 5001);
builder.AddContainer("test-nagular", "kevinfgr/test-angular").WithHttpEndpoint(targetPort: 80).WithEndpoint("http", x => x.Port = 4200);

builder.Build().Run();

// test
// // observaçõe para rodar em deploy 
// using Microsoft.Extensions.Hosting.WindowsServices;

// var builder = DistributedApplication.CreateBuilder(args);

// builder.Services.Configure<HostOptions>(opts => {
//     opts.BackgroundServiceExceptionBehavior = BackgroundServiceExceptionBehavior.Ignore;
// });

// builder.Build().RunAsWindowsService();