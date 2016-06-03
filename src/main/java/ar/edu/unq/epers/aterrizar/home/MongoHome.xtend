package ar.edu.unq.epers.aterrizar.home

import java.util.List
import org.mongojack.AggregationResult
import org.mongojack.DBQuery.Query
import org.mongojack.JacksonDBCollection
import org.mongojack.MapReduce
import ar.edu.unq.epers.aterrizar.servicios.Aggregation
import com.mongodb.DBObject
import org.mongojack.DBQuery

class MongoHome<T> {
	private JacksonDBCollection<T, String> mongoCollection
	var Class<T> entityType
	
	new(JacksonDBCollection<T, String> collection, Class<T> entityType){
		this.mongoCollection = collection
		this.entityType = entityType
	}
	
	new(JacksonDBCollection<T, String> collection){
		this.mongoCollection = collection
	}
	
	def insert(T object){
		return mongoCollection.insert(object);
    }
	
	def insert(List<T> object){
		return mongoCollection.insert(object);
    }
    
    def find(Query object){
		return mongoCollection.find(object);
    }
    
    def update(Query queryObject, T object) {
    	return mongoCollection.update(queryObject, object, true, false)
    }
    
    def List<T> find(Aggregation<T> aggregation) {
    	new AggregationResult<T>(mongoCollection, 
    		mongoCollection.dbCollection.aggregate(aggregation.build),
    		entityType
    	).results
    }
    
    def aggregate(){
    	new Aggregation(this)	
    }
    
	def <E, S>  mapReduce(String map, String reduce, Class<E> entrada, Class<S> salida){
		return mongoCollection.mapReduce(mapReduceCommand(map, reduce, entrada, salida));
	}
	
	def <E, S> mapReduce(String map, String reduce, String finalize, Class<E> entrada, Class<S> salida){
		return mongoCollection.mapReduce(mapReduceCommand(map, reduce, finalize, entrada, salida));
	}
	
	def <E, S> mapReduceCommand(String map, String reduce, Class<E> entrada, Class<S> salida){
		return MapReduce.build(map, reduce, MapReduce.OutputType.INLINE, null, entrada, salida);
	}
	
	def <E, S> mapReduceCommand(String map, String reduce, String finalize, Class<E> entrada, Class<S> salida){
		val command = this.mapReduceCommand(map, reduce, entrada, salida);
		command.setFinalize(finalize);
		return command;
	}
	
	def setMongoCollection(JacksonDBCollection<T, String> mongoCollection) {
		this.mongoCollection = mongoCollection;
	}
	
	def getMongoCollection() {
		return mongoCollection;
	}
	
	 def update(T object){
    //	mongoCollection.remove(object as DBObject);
//    	var objeto = this.find(object)
		return mongoCollection.save(object);
    }
}