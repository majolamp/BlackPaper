using Dapper;
using BlackPaper.Core.Models;
using BlackPaper.Core.Interfaces;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System;
using System.Linq;
using Microsoft.Extensions.Logging;

namespace BlackPaper.Repository
{
    public class CustomerRepository:BaseRepository, IRepository<Customer>
    {
        private readonly ConnectionString _connectionString;
        private readonly ILogger<CustomerRepository> _logger;
        public CustomerRepository(ConnectionString connectionString, ILogger<CustomerRepository> logger)
        {
            _connectionString = connectionString;
            _logger = logger;
        }
        public int Add(Customer entity)
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            DynamicParameters parameters = new DynamicParameters();
            try
            {
                parameters.Add("@FirstName", entity.FirstName);
                parameters.Add("@LastName", entity.LastName);
                parameters.Add("@Email", entity.Email);
                parameters.Add("@Password", entity.Password);
                parameters.Add("@CustomerId", dbType: DbType.String, direction: ParameterDirection.Output, size: 5215585);
                SqlMapper.Execute(connection, "customer.pr_AddCustomer", parameters, commandType: CommandType.StoredProcedure);
                entity.ProductId = Int32.Parse(parameters.Get<string>("@CustomerId"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }
            return entity.ProductId;

        }

        public void Delete(int id)
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            DynamicParameters parameters = new DynamicParameters();
            try
            {
                parameters.Add("@CustomerId", id);
                SqlMapper.Execute(connection, "customer.pr_DeleteCustomer", param: parameters, commandType: CommandType.StoredProcedure);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }
        }

        public IEnumerable<Customer> GetAll()
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            DynamicParameters parameters = new DynamicParameters();
            try
            {
                IEnumerable<Customer> customerList = SqlMapper.Query<Customer>(connection, "customer.pr_GetAllCustomer", parameters, commandType: CommandType.StoredProcedure).ToList();
                return customerList;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }
        }

        public Customer GetById(int id)
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            DynamicParameters parameters = new DynamicParameters();
            try
            {
                parameters.Add("@CustomerId", id);
                return SqlMapper.Query<Customer>((SqlConnection)connection, "customer.pr_GetCustomerById", parameters, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }
        }

        public void Update(Customer entity)
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            DynamicParameters parameters = new DynamicParameters();
            try
            {
                parameters.Add("@FirstName", entity.FirstName);
                parameters.Add("@LastName", entity.LastName);
                parameters.Add("@Email", entity.Email);
                parameters.Add("@Password", entity.Password);
                parameters.Add("@CustomerId", entity.ProductId);
                SqlMapper.Execute(connection, "customer.pr_UpdateCustomer", parameters, commandType: CommandType.StoredProcedure);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }



        }
    }
}
