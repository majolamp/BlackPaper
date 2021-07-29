using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace BlackPaper.Repository
{
    public class BaseRepository
    {
        protected IDbConnection connection;
        public IDbConnection DapperConnetion
        {
            get
            {
                return new SqlConnection(ConfigurationManager.ConnectionStrings["Default"].ToString());
            }
        }

    }
}
