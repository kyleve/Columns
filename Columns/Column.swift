//
//  Column.swift
//  Columns
//
//  Created by Kyle Van Essen on 8/8/19.
//  Copyright © 2019 Kyle Van Essen. All rights reserved.
//

import UIKit


struct ColumnLayout
{
    let all : [ColumnLayoutElement]
    let columns : [Column]
    let gutters : [Gutter]
    
    init(totalWidth: CGFloat, columns columnsCount: Int, gutterWidth: CGFloat)
    {
        precondition(totalWidth > CGFloat(columnsCount))
        precondition(columnsCount > 0)
        precondition(gutterWidth >= 0)
        
        let gutterCount : Int = columnsCount - 1
        let totalGutterWidth = gutterWidth * CGFloat(gutterCount)

        let totalColumnWidth = totalWidth - totalGutterWidth
        let columnWidth = totalColumnWidth / CGFloat(columnsCount)
        
        // TODO: This doesn't take into account the fact that we need to iterate over each column and use
        // bubble roundint to figure out the actual widths.. but good enough for now.
        
        var all = [ColumnLayoutElement]()
        var columns = [Column]()
        var gutters = [Gutter]()
        
        var offset : CGFloat = 0.0
        
        for index in 0 ..< columnsCount
        {
            let isLastColumn = (index == columnsCount - 1)
            
            let column = Column(
                width: columnWidth,
                offset: offset,
                index: index
            )
            
            all.append(column)
            columns.append(column)
            
            offset += column.width
            
            if isLastColumn == false {
                let gutter = Gutter(
                    width: gutterWidth,
                    offset: offset,
                    index: index
                )
                
                offset += gutterWidth
                
                all.append(gutter)
                gutters.append(gutter)
            }
        }
        
        self.all = all
        self.columns = columns
        self.gutters = gutters
    }
}

protocol ColumnLayoutElement
{
    var width : CGFloat { get }
    var offset : CGFloat { get }
    
    var index : Int { get }
}

struct Column : ColumnLayoutElement
{
    let width : CGFloat
    let offset : CGFloat
    
    let index : Int
}

struct Gutter : ColumnLayoutElement
{
    let width : CGFloat
    let offset : CGFloat
    
    let index : Int
}

struct FourColumnLayout
{
    let layout : ColumnLayout
    
    init(totalWidth: CGFloat, gutterWidth: CGFloat)
    {
        self.layout = ColumnLayout(totalWidth: totalWidth, columns: 4, gutterWidth: gutterWidth)
        
        self.column1 = self.layout.columns[0]
        self.column2 = self.layout.columns[1]
        self.column3 = self.layout.columns[2]
        self.column4 = self.layout.columns[3]
        
        self.gutter1 = self.layout.gutters[0]
        self.gutter2 = self.layout.gutters[1]
        self.gutter3 = self.layout.gutters[2]
    }
    
    let column1 : Column
    let column2 : Column
    let column3 : Column
    let column4 : Column
    
    let gutter1 : Gutter
    let gutter2 : Gutter
    let gutter3 : Gutter
}
