using System.Collections.Generic;


namespace BlackPaper.Core.Interfaces
{
    public interface IRepository<T> where T:class
    {
        int Add(T entity);
        void Update(T entity);
        void Delete(int id);
        IEnumerable<T> GetAll();
        T GetById(int id);
    }
}
