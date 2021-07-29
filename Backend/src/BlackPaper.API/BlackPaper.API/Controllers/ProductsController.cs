using System.Collections.Generic;
using System.Net;
using BlackPaper.Core.Interfaces;
using BlackPaper.Core.Models;
using Microsoft.AspNetCore.Mvc;

namespace BlackPaper.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly IRepository<Product> _productRepository;
        public ProductController(IRepository<Product> productRepository)
        {
            _productRepository = productRepository;
        }

        [HttpGet]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public IEnumerable<Product> GetProduct()
        {
            return _productRepository.GetAll();
        }

        [HttpGet("{id}")]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public Product GetProductById(int id)
        {
            return _productRepository.GetById(id);
        }

        [HttpPost]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public ActionResult AddProduct([FromBody]Product product)
        {
            _productRepository.Add(product);
            return Ok(product.ProductId);

        }

        [HttpPut]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public ActionResult UpdateProduct([FromBody]Product product)
        {
            _productRepository.Update(product);
            return Ok(product.ProductId);

        }

        [HttpDelete("{id}")]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public void Delete(int id)
        {
            _productRepository.Delete(id);
        }
    }
}