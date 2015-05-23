# neo4hub

Importer from [GitHub API](https://developer.github.com/v3/) to [Neo4j](http://neo4j.com/) with [Neo4j.rb](http://neo4jrb.io/).

Used for my [RubyC](http://rubyc.eu/) presentation.

# Some examples

## Popularity

```
MATCH (o:Organization)-[m:MEMBER]->()
RETURN o, COUNT(m) as c
ORDER BY c DESC
LIMIT 5
```
```
MATCH ()-[f:FOLLOWS]->(u:User)
RETURN u, COUNT(f) as c
ORDER BY c DESC
LIMIT 5
```
```
MATCH (r:Repository)-[f:FORK]->()
RETURN r, count(f) as c
ORDER BY c DESC
LIMIT 5
```

## Shortest paths

- `MATCH (ptujec:User{login:'Ptujec'}), (inakata:User{login:'inakata'}),  p = allShortestPaths((ptujec)-[*]-(inakata)) RETURN p`
- `MATCH (thekemkid:User{login:'thekemkid'}), (inakata:User{login:'inakata'}),  p = allShortestPaths((thekemkid)-[*]-(inakata)) RETURN p`
- `MATCH (thekemkid:User{login:'thekemkid'}), (inakata:User{login:'inakata'}),  p = shortestPath((thekemkid)-[*]-(inakata)) RETURN p`

## Misc

### Who forked Rails

```
MATCH (r:Repository{full_name:'rails/rails'})-[:FORK]->(f)<-[:OWNS]-(u:User)
RETURN r, f, u
```

### Friday hug

```
MATCH (tenderlove:User{login:'tenderlove'})-->(f)-->(tenderlove)
RETURN f, tenderlove
```

### Most source repos

```
MATCH (u:User)-[o:OWNS]->(r:Repository{source:true})
RETURN u, COUNT(o) as c
ORDER BY c DESC
LIMIT 10
```

### Most forks

```
MATCH (u:User)-[o:OWNS]->(r:Repository)
WHERE r.source = false
RETURN u, COUNT(o) as c
ORDER BY c DESC
LIMIT 10
```

### Source repos of @RubySlovenia members

```
MATCH (o:Organization{login:'RubySlovenia'})-->(u)-->(r:Repository{source:true})
RETURN u.name, collect(r.name), count(r) AS c
ORDER BY c DESC
```
