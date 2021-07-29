using BlackPaper.Core.Interfaces;
using BlackPaper.Core.Models;
using Dapper;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace BlackPaper.Repository
{
    public class ProductRepository : BaseRepository, IRepository<Product>
    {
        private readonly ConnectionString _connectionString;
        private readonly ILogger<ProductRepository> _logger;
        public ProductRepository(ConnectionString connectionString, ILogger<ProductRepository> logger)
        {
            _connectionString = connectionString;
            _logger = logger;
        }
        public int Add(Product entity)
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            DynamicParameters parameters = new DynamicParameters();
            try
            {
                parameters.Add("@ProductName", entity.ProductName);
                parameters.Add("@ProductDescription", entity.ProductDescription);
                parameters.Add("@ImageUrl", entity.ImageUrl);
                parameters.Add("@Price", entity.Price);
                parameters.Add("@ProductId", dbType: DbType.String, direction: ParameterDirection.Output, size: 5215585);
                SqlMapper.Execute(connection, "product.pr_AddProduct", parameters, commandType: CommandType.StoredProcedure);
                entity.ProductId = Int32.Parse(parameters.Get<string>("@ProductId"));
            }
            catch(Exception ex)
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
                parameters.Add("@ProductId", id);
                SqlMapper.Execute(connection, "product.pr_DeleteProduct", param: parameters, commandType: CommandType.StoredProcedure);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }

        }

        public IEnumerable<Product> GetAll()
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            try
            { 
                DynamicParameters parameters = new DynamicParameters();
                IEnumerable<Product> productList = SqlMapper.Query<Product>(connection, "product.pr_GetAllProduct", parameters, commandType: CommandType.StoredProcedure).ToList();
                return productList;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }
        }

        public Product GetById(int id)
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            DynamicParameters parameters = new DynamicParameters();
            try
            {
                parameters.Add("@ProductId", id);
                return SqlMapper.Query<Product>((SqlConnection)connection, "product.pr_GetProductById", parameters, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }
        }

        public void Update(Product entity)
        {
            using IDbConnection connection = new SqlConnection(_connectionString.Value);
            connection.Open();
            DynamicParameters parameters = new DynamicParameters();
            try
            {
                parameters.Add("@ProductName", entity.ProductName);
                parameters.Add("@ProductDescription", entity.ProductDescription);
                parameters.Add("@ProductId", dbType: DbType.String, direction: ParameterDirection.Output, size: 5215585);
                SqlMapper.Execute(connection, "product.pr_UpdateProduct", parameters, commandType: CommandType.StoredProcedure);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"A general exception occured while processing {ex.Message}.");
                throw;
            }

        }
    }
}
