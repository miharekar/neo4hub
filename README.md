# neo4hub

Importer from [GitHub API](https://developer.github.com/v3/) to [Neo4j](http://neo4j.com/) with [Neo4j.rb](http://neo4jrb.io/).

Used for my [RubyC](http://rubyc.eu/) and [Rails Remote Conf](https://railsremoteconf.com/) talks.

# Some examples

## Popularity

```
MATCH (o:Organization)-[m:MEMBER]->()
RETURN o, COUNT(m) as c
ORDER BY c DESC
LIMIT 5

MATCH ()-[f:FOLLOWS]->(u:User)
RETURN u, COUNT(f) as c
ORDER BY c DESC
LIMIT 5

MATCH (r:Repository)-[f:FORK]->()
RETURN r, count(f) as c
ORDER BY c DESC
LIMIT 5

MATCH (t:User{login:'tenderlove'})<--(u:User)-->(m:User{login:'mrfoto'})
RETURN t, u, m
```

## Organizations

```
MATCH (rs:Organization{login:'RubySlovenia'})-->(m:User)
RETURN rs, m

MATCH (rs:Organization{login:'RubySlovenia'})-->(m)<--(f:User)
RETURN m, f

MATCH (rs:Organization{login:'RubySlovenia'})-->(m)<--(f:User)
RETURN f.login

MATCH (rs:Organization{login:'RubySlovenia'})-->(m)<--(f:User)
RETURN COUNT(f)
```

## Shortest paths

```
MATCH (yehuda:User{login:'wycats'}), (jacek:User{login:'ncr'}),  p = allShortestPaths((yehuda)-[*]-(jacek))
RETURN p

MATCH (yehuda:User{login:'wycats'}), (jacek:User{login:'ncr'}),  p = shortestPath((yehuda)-[*]-(jacek))
RETURN p
```

## Misc

### Source repos of @RubySlovenia members

```
MATCH (o:Organization{login:'RubySlovenia'})-->(u)-->(r:Repository{source:true})
RETURN u, r

MATCH (o:Organization{login:'RubySlovenia'})-->(u)-->(r:Repository{source:true})
RETURN u.name, collect(r.name), count(r) AS c
ORDER BY c DESC
```

### Who forked Rails

```
MATCH (r:Repository{full_name:'rails/rails'})-[:FORK]->(f)<-[:OWNS]-(u:User)
RETURN r, f, u
```

### Friday hug

```
MATCH (tenderlove:User{login:'tenderlove'})-->(f:User)-->(tenderlove)
RETURN f, tenderlove
```

### Most repos/forks

```
MATCH (u:User)-[o:OWNS]->(r:Repository{source:true})
RETURN u.name, u.login, COUNT(o) as c
ORDER BY c DESC
LIMIT 10

MATCH (u:User)-[o:OWNS]->(r:Repository{source:false})
RETURN u.name, u.login, COUNT(o) as c
ORDER BY c DESC
LIMIT 10
```
