using Microsoft.EntityFrameworkCore;

using PortTrackingSystem.Api.Infrastructure.Data;

var builder = WebApplication.CreateBuilder(args);

const string AllowAll = "AllowAll";

builder.Services.AddCors(opt =>
{
    opt.AddPolicy(AllowAll, p =>
        p.WithOrigins(
            "http://localhost:5173",   // Web için
            "http://10.0.2.2:56976",    // Android Emulator
            "http://localhost:5000"    // Backend test için
        )
        .AllowAnyHeader()
        .AllowAnyMethod());
});


builder.Services.AddDbContext<AppDbContext>(options =>

    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();

app.UseSwaggerUI();

app.UseRouting(); // ✅ CORS'tan önce eklenmeli

app.UseCors(AllowAll); // ✅ burada olmalı

app.UseAuthorization();

app.MapControllers();

app.Run();

