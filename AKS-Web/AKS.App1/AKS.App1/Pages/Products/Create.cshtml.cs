using AKS.App1.Application.Context;
using AKS.App1.Models.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace AKS.App1.Pages.Products;

public class CreateModel(ProductDbContext context) : PageModel
{
    [BindProperty]
    public Product Product { get; set; } = new();
    public List<SelectListItem> CategoryOptions { get; set; } = new();

    public async Task OnGetAsync()
    {
        CategoryOptions = await context.ProductCategories
            .Select(c => new SelectListItem
            {
                Value = c.CategoryId.ToString(),
                Text = c.CategoryName
            })
            .ToListAsync();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        //    if (!ModelState.IsValid)
        //    {
        //        await OnGetAsync(); // reload categories if form invalid
        //        return Page();
        //    }

        context.Products.Add(Product);
        await context.SaveChangesAsync();
        return RedirectToPage("/Products/Index");
    }
}
