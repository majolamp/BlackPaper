using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace BlackPaper.Core.Models
{
    public class Product
    {
        [JsonPropertyName("id")]
        public int ProductId { get; set; }
        [JsonPropertyName("name")]
        public string ProductName { get; set; }
        [JsonPropertyName("description")]
        public string ProductDescription { get; set; }
        [JsonPropertyName("imageUrl")]
        public string ImageUrl { get; set; }
        [JsonPropertyName("price")]
        public decimal Price { get; set; }
        //public string ProductColor { get; set; }
        //public int ProductSize { get; set; }
    }
}
