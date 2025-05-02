using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace AKS.App1.Models.Entities;

public class ProductCategory
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int CategoryId { get; set; }

    [Required]
    [MaxLength(100)] 
    public string? CategoryName { get; set; }
    //[AllowNull]
    //[NotMapped]
    public ICollection<Product> Products { get; set; } = new HashSet<Product>();
    //public ICollection<Product>? Products { get; set; }
}
