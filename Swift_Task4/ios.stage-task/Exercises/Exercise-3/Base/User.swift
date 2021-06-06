import Foundation

struct User: Equatable, Hashable {
    let id: UUID

func hash(_ hash: inout Hasher) {
     hash.combine(self.id)
   }
}
