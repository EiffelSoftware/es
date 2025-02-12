# Vector Search Tutorial

This tutorial series demonstrates how to implement vector search capabilities using MongoDB Atlas and Eiffel. Follow along to build an intelligent search system that understands semantic meaning and finds relevant documents based on conceptual similarity.

## Prerequisites
- MongoDB Atlas account
- Access to the sample_mflix database
- Eiffel development environment
- Valid `config.json` with MongoDB connection string:
```json
{
   "connection_string": "your_atlas_connection_string"
}
```

## Tutorial Steps

### Step 1: Creating a Vector Search Index
Learn how to set up and monitor a vector search index:
- Create a vector search index on the `sample_mflix.embedded_movies` collection
- Configure the index for the `plot_embedding` field (1536 dimensions)
- Use dotProduct similarity measurement with scalar quantization
- Monitor the index building process

[Source Code](./step1)

### Step 2: Running Vector Search Queries
Learn how to perform semantic searches using vector embeddings:
- Use the `$vectorSearch` aggregation stage to find similar documents
- Search movie plots using semantic meaning rather than exact text matches
- Configure search parameters like number of results and similarity thresholds
- Project relevant fields and scores in the results

Example query that searches for movies similar to "time travel":
```query
[
  {
    $vectorSearch: {
      index: "vector_index",
      path: "plot_embedding",
      queryVector: <embedding_for_time_travel>,
      numCandidates: 150,
      limit: 10
    }
  },
  {
    $project: {
      _id: 0,
      title: 1,
      plot: 1,
      score: { $meta: "vectorSearchScore" }
    }
  }
]
```

[Source Code](./step2)
[Documentation](https://www.mongodb.com/docs/atlas/atlas-vector-search/tutorials/vector-search-quick-start/?tck=ai_as_web#run-a-vector-search-query)

## Resources
- [MongoDB Atlas Vector Search Documentation](https://www.mongodb.com/docs/atlas/atlas-vector-search/tutorials/vector-search-quick-start/?tck=ai_as_web)
- [OpenAI Embeddings Documentation](https://platform.openai.com/docs/guides/embeddings)

