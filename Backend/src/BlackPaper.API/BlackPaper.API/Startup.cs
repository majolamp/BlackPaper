using BlackPaper.Core.Interfaces;
using BlackPaper.Core.Models;
using BlackPaper.Repository;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Diagnostics;
using System.Net;
using System.Reflection;
using System.Runtime;
using System.Text;

namespace BlackPaper.API
{
    public class Startup
    {
        /// <summary>
        /// Gets the current configuration
        /// </summary>
        public IConfiguration Configuration { get; }
        /// <summary>
        /// Name of the application
        /// </summary>
        public string ApplicationName { get; set; }
        /// <summary>
        /// The current hosting environment
        /// </summary>
        public IHostEnvironment HostingEnvironment { get; set; }
        /// <summary>
        /// Initializes a new instance of the <see cref="Startup"/>
        /// </summary>
        /// <param name="configuration"></param>
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            ApplicationName = Configuration["ApiInf:ApplicationName"];
        }

       // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            var connectionString = new ConnectionString(Configuration.GetConnectionString("Default"));
            services.AddSingleton(connectionString);
            services.AddControllers();
            services.AddTransient<IRepository<Customer>, CustomerRepository>();
            services.AddTransient<IRepository<Product>, ProductRepository>();
            services.AddSwaggerGen();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "BlackPaperAPI");
            });

            app.UseRouting();
            app.UseCors(x => x
               .AllowAnyMethod()
               .AllowAnyHeader()
               .SetIsOriginAllowed(origin => true) // allow any origin
               .AllowCredentials()); // allow credentials

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }

        private void LogInitialisationComplete(ILogger<Startup> logger)
        {
            var sb = new StringBuilder();
            sb.AppendFormat("Initialisation complete for {0}:", ApplicationName);
            sb.AppendLine();
            sb.AppendFormat("  ProcessID                    {0}", Process.GetCurrentProcess().Id);
            sb.AppendLine();
            sb.AppendFormat("  Platform                     {0}", Environment.Is64BitProcess ? "64-bit (x64)" : "32-bit (x86)");
            sb.AppendLine();
            sb.AppendFormat("  Runtime                      {0}", Environment.Version);
            sb.AppendLine();
            sb.AppendFormat("  NumCPUs                      {0}", Environment.ProcessorCount);
            sb.AppendLine();
            sb.AppendFormat("  ServerGC                     {0}", GCSettings.IsServerGC);
            sb.AppendLine();
            sb.AppendFormat("  HttpConnectionLimit          {0}", ServicePointManager.DefaultConnectionLimit);
            sb.AppendLine();

#if DEBUG
            sb.AppendFormat("  BuildType                    Debug");
            sb.AppendLine();
#else
      sb.AppendFormat("  BuildType                    Release");
      sb.AppendLine();
#endif
            sb.AppendFormat("  ASPNETCORE_ENVIRONMENT       {0}", HostingEnvironment.EnvironmentName);
            sb.AppendLine();
            sb.AppendFormat("  Version                      {0}", FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location).FileVersion);
            sb.AppendLine();

            logger.LogInformation(sb.ToString());
        }
        private void HandleApiStartup(ILogger<Startup> logger)
        {
            // Any API specific startup code
            // Do some code :)

            LogInitialisationComplete(logger);
        }
    }
}
