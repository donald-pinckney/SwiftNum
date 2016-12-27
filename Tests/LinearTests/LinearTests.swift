import XCTest
@testable import Linear

class LinearTests: XCTestCase {
    
    // TESTING MATRICES:
    let magic = Matrix([
        [16, 2, 3, 13],
        [5, 11, 10, 8],
        [9, 7, 6, 12],
        [4, 14, 15, 1]
    ])
    
    let magicAdded = Matrix([
        [32, 4, 6, 26],
        [10, 22, 20, 16],
        [18, 14, 12, 24],
        [8, 28, 30, 2]
    ])
    
    let magicSquared = Matrix([
        [345, 257, 281, 273],
        [257, 313, 305, 281],
        [281, 305, 313, 257],
        [273, 281, 257, 345]
    ])
    
    let numConcatHorz = Matrix([[1, 2, 3, 4, 5]])
    let numConcatVert = Matrix([[1], [2], [3], [4], [5]])
    
    // This is magicAdded horz concat magicSquared
    let magicHorzConcat = Matrix([
        [32, 4, 6, 26, 345, 257, 281, 273],
        [10, 22, 20, 16, 257, 313, 305, 281],
        [18, 14, 12, 24, 281, 305, 313, 257],
        [8, 28, 30, 2, 273, 281, 257, 345]
    ])
    
    let magicNumHorzConcat = Matrix([
        [0, 32, 4, 6, 26, 9, 345, 257, 281, 273, 1],
        [0, 10, 22, 20, 16, 9, 257, 313, 305, 281, 1],
        [0, 18, 14, 12, 24, 9, 281, 305, 313, 257, 1],
        [0, 8, 28, 30, 2, 9, 273, 281, 257, 345, 1]
    ])
    
    // This is magicAdded vert concat magicSquared
    let magicVertConcat = Matrix([
        [32, 4, 6, 26],
        [10, 22, 20, 16],
        [18, 14, 12, 24],
        [8, 28, 30, 2],
        [345, 257, 281, 273],
        [257, 313, 305, 281],
        [281, 305, 313, 257],
        [273, 281, 257, 345]
    ])
    
    let magicNumVertConcat = Matrix([
        [0, 0, 0, 0],
        [32, 4, 6, 26],
        [10, 22, 20, 16],
        [18, 14, 12, 24],
        [8, 28, 30, 2],
        [9, 9, 9, 9],
        [345, 257, 281, 273],
        [257, 313, 305, 281],
        [281, 305, 313, 257],
        [273, 281, 257, 345],
        [1, 1, 1, 1]
    ])
    // ------------------------------------
    
    
    // ACTUAL TESTS:
    
    func testMatrixAdd() {
        XCTAssertEqual(magic + magic, magicAdded)
        
        var magic2 = magic
        magic2 += magic
        XCTAssertEqual(magic2, magicAdded)
    }
    
    func testMatrixScalarMult() {
        XCTAssertEqual(magic * 2, magicAdded)
        XCTAssertEqual(2 * magic, magicAdded)

        var magic2 = magic
        magic2 *= 2
        XCTAssertEqual(magic2, magicAdded)

    }
    
    func testMatrixMult() {
        XCTAssertEqual(magic * magic, magicSquared)
        
        var magic2 = magic
        magic2 *= magic
        XCTAssertEqual(magic2, magicSquared)
    }

    func testMatrixHorzCat() {
        XCTAssertEqual(Matrix.horizontalConcatenate([1, 2, 3, 4, 5]), numConcatHorz)
        XCTAssertEqual(Matrix.horizontalConcatenate([magicAdded, magicSquared]), magicHorzConcat)
        XCTAssertEqual(Matrix.horizontalConcatenate([0, magicAdded, 9, magicSquared, 1]), magicNumHorzConcat)
    }
    
    func testMatrixVertCat() {
        XCTAssertEqual(Matrix.verticalConcatenate([1, 2, 3, 4, 5]), numConcatVert)
        XCTAssertEqual(Matrix.verticalConcatenate([magicAdded, magicSquared]), magicVertConcat)
        XCTAssertEqual(Matrix.verticalConcatenate([0, magicAdded, 9, magicSquared, 1]), magicNumVertConcat)
    }
    
    func testZeroMatrix() {
        XCTAssertEqual(magic + Matrix.zeros(magic.height, magic.width), magic)
    }
    
    func testIdentityMatrix() {
        XCTAssertEqual(magic * Matrix.I(magic.width), magic)
    }
    
    func testMatrixSubscripts() {
        XCTAssertEqual(magic[0, 0], 16)
        XCTAssertEqual(magic[magic.height-1, magic.width-1], 1)
        let subMagic = Matrix([
            [2, 3],
            [11, 10],
            [7, 6]
        ])
        
        
        XCTAssertEqual(magic[0...2, 1...2], subMagic)
        XCTAssertEqual(magic[0..<3, 1...2], subMagic)
        XCTAssertEqual(magic[0...2, 1..<3], subMagic)
        XCTAssertEqual(magic[0..<3, 1..<3], subMagic)

        let subMagicChange = Matrix([
            [7, 8],
            [9, 10],
            [11, 12]
        ])
        let newMagic = Matrix([
            [16, 7, 8, 13],
            [5, 9, 10, 8],
            [9, 11, 12, 12],
            [4, 14, 15, 1]
        ])

        

        
        var magic2 = magic
        
        magic2[0, 0] = -34
        XCTAssertEqual(magic2, Matrix([
            [-34, 2, 3, 13],
            [5, 11, 10, 8],
            [9, 7, 6, 12],
            [4, 14, 15, 1]
        ]))
        magic2 = magic
        
        
        magic2[0...2, 1...2] = subMagicChange
        XCTAssertEqual(magic2, newMagic)
        magic2 = magic
        
        magic2[0..<3, 1...2] = subMagicChange
        XCTAssertEqual(magic2, newMagic)
        magic2 = magic
        
        magic2[0...2, 1..<3] = subMagicChange
        XCTAssertEqual(magic2, newMagic)
        magic2 = magic
        
        magic2[0..<3, 1..<3] = subMagicChange
        XCTAssertEqual(magic2, newMagic)
        magic2 = magic
    }
    
    func testMatrixInverse() {
        let magic3 = Matrix([
            [8, 1, 6],
            [3, 5, 7],
            [4, 9, 2]
        ])
        
        XCTAssertEqualWithAccuracy(magic3 * magic3.inverse()!, Matrix.I(3), accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(magic3.inverse()! * magic3, Matrix.I(3), accuracy: 0.00001)
        
        XCTAssertEqual(Matrix.zeros(3, 3).inverse(), nil)
    }

    static var allTests : [(String, (LinearTests) -> () throws -> Void)] {
        return [
            ("testMatrixAdd", testMatrixAdd),
            ("testMatrixScalarMult", testMatrixScalarMult),
            ("testMatrixMult", testMatrixMult),
            ("testMatrixHorzCat", testMatrixHorzCat),
            ("testMatrixVertCat", testMatrixVertCat),
            ("testZeroMatrix", testZeroMatrix),
            ("testIdentityMatrix", testIdentityMatrix),
            ("testMatrixSubscripts", testMatrixSubscripts),
            ("testMatrixInverse", testMatrixInverse),
        ]
    }
}
