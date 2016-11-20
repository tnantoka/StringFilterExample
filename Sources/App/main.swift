import Vapor
import Fluent

let drop = Droplet()

let database = Database(MemoryDriver())
drop.database = database
drop.preparations.append(Example.self)

drop.get { req in
    return try drop.view.make("welcome")
}

drop.resource("examples", ExampleController())

drop.run()
