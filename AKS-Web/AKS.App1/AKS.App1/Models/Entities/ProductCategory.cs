using System.ComponentModel.DataAnnotations;

namespace AKS.App1.Models.Entities;

public class ProductCategory
{
    [Key]
    public int CategoryId { get; set; }

    public string CategoryName { get; set; }
    public List<Product> Products { get; set; }
}
