using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using BlackPaper.Core.Interfaces;
using BlackPaper.Core.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BlackPaper.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomerController : ControllerBase
    {
        private readonly IRepository<Customer> _customerRepository;
        public CustomerController(IRepository<Customer> customerRepository)
        {
            _customerRepository = customerRepository;
        }
        [HttpGet]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public IEnumerable<Customer> GetCustomer()
        {
            return _customerRepository.GetAll();

        }

        [HttpGet("{id}")]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public Customer GetCustomerById(int id)
        {
            return _customerRepository.GetById(id);
        }

        [HttpPost]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public ActionResult AddCustomer([FromBody]Customer customer)
        {
            _customerRepository.Add(customer);
            return Ok(customer.ProductId);

        }

        [HttpPut]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public ActionResult UpdateCustomer([FromBody]Customer customer)
        {
            _customerRepository.Update(customer);
            return Ok(customer.ProductId);

        }

        [HttpDelete("{id}")]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.BadRequest)]
        [ProducesResponseType(typeof(object), (int)HttpStatusCode.InternalServerError)]
        public void Delete(int id)
        {
            _customerRepository.Delete(id);
        }
    }
}