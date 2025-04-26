using AKS.App1.Application.Context;
using AKS.App1.Models.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;

namespace AKS.App1.Pages.Products
{
    public class IndexModel(ProductDbContext context) : PageModel
    {
        public List<Product> Products { get; set; } = new();
        public async Task OnGet()
        {
            Products = await context.Products
               .Include(p => p.ProductCategory) // eager load category
               .ToListAsync();
        }
    }
}
