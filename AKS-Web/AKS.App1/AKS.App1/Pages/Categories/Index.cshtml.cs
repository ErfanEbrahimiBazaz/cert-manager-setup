using AKS.App1.Application.Context;
using AKS.App1.Models.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;

namespace AKS.App1.Pages.Categories
{
    public class IndexModel(ProductDbContext context) : PageModel
    {
        public List<ProductCategory> Categories { get; set; } = new();
        public async Task OnGet()
        {
            Categories = await context.ProductCategories.ToListAsync();
        }
    }
}
