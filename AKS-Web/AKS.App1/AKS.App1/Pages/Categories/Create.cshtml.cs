using AKS.App1.Application.Context;
using AKS.App1.Models.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;

namespace AKS.App1.Pages.Categories;

public class CreateModel(ProductDbContext context) : PageModel
{
    [BindProperty]
    public ProductCategory ProductCategory { get; set; } = new();
    public void OnGet()
    {
    }
    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
            return Page();

        context.ProductCategories.Add(ProductCategory);
        await context.SaveChangesAsync();
        return RedirectToPage("/Categories/Index");
    }
}

