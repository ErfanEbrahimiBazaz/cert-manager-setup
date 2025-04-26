using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AKS.App1.Models.Entities;

public class Product
{
    [Key]
    public int ProductId { get; set; }
    [Required]
    public string ProductName { get; set; }
    public virtual ProductCategory ProductCategory { get; set; }

    [ForeignKey(nameof(ProductCategory))]
    public int ProductCategoryId { get; set; }

}

