using AKS.App1.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace AKS.App1.Application.Context;

public class ProductDbContext: DbContext
{
    public ProductDbContext(DbContextOptions<ProductDbContext> options): base(options)
    {
        
    }
    public DbSet<ProductCategory> ProductCategories{ get; set; }
    public DbSet<Product> Products{get; set; }


}
