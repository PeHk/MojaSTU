//
//  HTMLParser.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 14/11/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//
/*
// MARK: - Info

// In this class we can find all functions for parsing XPath queries
 to HTML answers from AIS server - get the values for next operations
*/


import Foundation
import Kanna
import SwiftSoup

class HTMLParser: NSObject {
    
    let stringparser: StringParser = StringParser()
    
//    MARK: Get XPathValue
    func getXPathvalue(xPath: String, fromHtml: String) -> String {
        
        var xPathValue = String()

        if let doc = try? HTML(html: fromHtml, encoding: .utf8) {

            for link in doc.xpath(xPath) {
                xPathValue = link.text!
            }
        }
        return xPathValue
    }
    
//    MARK: Get XPathLinkValue
    func getLinkXPath(xPath: String, fromHtml: String) -> String {
        var xPathValue = String()

        if let doc = try? HTML(html: fromHtml, encoding: .utf8) {

            for link in doc.xpath(xPath) {
                xPathValue = link["href"]!
            }
        }
        return xPathValue
    }
    
//    MARK: Message in email
    func parseMessage(fromHtml: String) -> (String, Array<Attachment>) {
        
        var finalText = String()
        var attachmentArray = [Attachment]()
        var text = String()
        
        do {
            let doc: Document = try SwiftSoup.parse(fromHtml)
            //Main table for text
            let mainTable = try doc.select("table[width=750] > tbody > tr:nth-child(8) > td")
            let textElements = try mainTable.get(0).select("span, div")
            //Second table, occassionally
            let secondTable = try doc.select("table[width=750] > tbody > tr:nth-child(9) > td")
            let secondTextElements = try secondTable.select("span, div")
            
            let tables = try doc.select("form > table")
            let attachmentTable = try tables.get(1).select("tbody > tr")
            
            if attachmentTable.count > 0 {
                for n in 1..<attachmentTable.count {
                    let nameColumn = try attachmentTable.get(n).select("td:nth-child(1)")
                    var name = try nameColumn.select("div, span").text()
                    var link = try nameColumn.select("div > a").attr("href")
                    if link.isEmpty {
                        link = try nameColumn.select("span > a").attr("href")
                    }
                    link = link.replacingOccurrences(of: "./", with: "https://is.stuba.sk/auth/posta/")
                    
                    name = stringparser.prefixWithoutVal(value: " [", string: name)
                    name = stringparser.suffixWithoutVal(value: ". ", string: name)
                    let attachmentObject = Attachment(name: name, link: link)
                    attachmentArray.append(attachmentObject)
                }
            }
            
            for element in textElements {
                text = try element.html()
            }

            text = text.replacingOccurrences(of: "\n", with: "")
            text = text.replacingOccurrences(of: "<br>", with: "\n")
            text = text.replacingOccurrences(of: "&nbsp;", with: " ")
            text = text.replacingOccurrences(of: "nbsp;", with: " ")
            text = text.replacingOccurrences(of: "&amp;", with: " ")
            
            if text == " " {
                for element in secondTextElements {
                    text = try element.html()
                }
                text = text.replacingOccurrences(of: "\n", with: "")
                text = text.replacingOccurrences(of: "<br>", with: "\n")
                text = text.replacingOccurrences(of: "&nbsp;", with: " ")
                text = text.replacingOccurrences(of: "nbsp;", with: " ")
                text = text.replacingOccurrences(of: "&amp;", with: " ")
            }

            text = "<p>" + text + "</p>"
            if let doc = try? HTML(html: text, encoding: .utf8) {

                for link in doc.css("p") {
                    finalText = link.text!
                }
            }
        }
        catch {
            print("Error")
        }

        return (finalText, attachmentArray)
    }
    
    func getAnswerEmail(fromHtml: String) -> Email {
        var email = Email()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return email}
            let subject = try doc.select("[name=Subject]").val()
            let name = try doc.select("[name=To]").val()
            let text = try doc.select("[name=Data]").text()
            let serialCode = try doc.select("[name=serializace]").val()
            let old_fid = try doc.select("[name=old_fid]").val()
            let old_eid = try doc.select("[name=old_eid]").val()
            let fid = try doc.select("[name=fid]").val()
            let eid = try doc.select("[name=eid]").val()
            
            email = Email(subject: subject, name: name, textOfEmail: text, serialCode: serialCode, old_eid: old_eid, old_fid: old_fid, fid: fid, eid: eid)
        }
        catch {
            print("Error")
        }
        
        
        return email
    }
    
    func getSerialization(fromHtml: String) -> Email{
        var email = Email()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return email}
            let serialCode = try doc.select("[name=serializace]").val()

            email = Email(serialCode: serialCode)
        }
        catch {
            print("Error")
        }
        
        return email
    }
    
    func getFolderID(fromHtml: String) -> String {
        var folderID = String()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return folderID}
            folderID = try doc.select("#144_tree > ul > li:nth-child(3) > div.node-container").attr("id")
        }
        catch {
            print("Error")
        }
        
        return folderID
    }
    
//    MARK: Parse subjects
    func getSubjectName(fromHtml: String) {

        EIndexSubject.sharedInstance.arrayOfSubjects.removeAll()
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return }
           
            let allRows = try doc.select("table#tmtab_1 > tbody > tr:not(.zahlavi)")
            let allColumns = try doc.select("table#tmtab_1 > tbody > tr.zahlavi > td")
            
            for n in 0..<allRows.count {
                let row = allRows.get(n)
                
                let firstColumn = try row.select("td:nth-child(1)")
                var nameFirstColum = try firstColumn.select("div > a").text()
                if nameFirstColum.isEmpty {
                    nameFirstColum = try firstColumn.select("span > a").text()
                }
                var name = String()
                print(nameFirstColum)
                if !nameFirstColum.isEmpty {
                    
                    name = nameFirstColum
                    name = stringparser.suffixWithoutVal(value: " ", string: name)
                    name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let sylabusColumn = try row.select("td:nth-child(1)")
                    var sylabus = try sylabusColumn.select("div > a").attr("href")
                    if sylabus.isEmpty {
                        sylabus = try sylabusColumn.select("span > a").attr("href")
                    }
                    
                    let sheetsColumn = try row.select("td:nth-child(\(allColumns.count - 3))")
                    var sheets = try sheetsColumn.select("div > a").attr("href")
                    if sheets.isEmpty {
                        sheets = try sheetsColumn.select("span > a").attr("href")
                    }
                    
                    let testColumn = try row.select("td:nth-child(\(allColumns.count))")
                    var tests = try testColumn.select("div > a").attr("href")
                    if tests.isEmpty {
                        tests = try testColumn.select("span > a").attr("href")
                    }
                    
                    let filesColumn = try row.select("td:nth-child(\(allColumns.count + 1))")
                    var files = try filesColumn.select("div > a").attr("href")
                    if files.isEmpty {
                        files = try filesColumn.select("span > a").attr("href")
                    }
                    files = files.replacingOccurrences(of: "..", with: "https://is.stuba.sk/auth")
                    var seminarPresence = [UIColor]()
                    let allWeeks = allRows.get(n)
                    let column = try allWeeks.select("td > span, div")
                    for i in 1..<column.count {
                        let images = try column.get(i).select("img")
                        let imageName = try images.attr("sysid")
                        
                        if imageName == "bullet-d" {
                            seminarPresence.append(.blue)
                        }
                        else if imageName == "doch-pritomen" {
                            seminarPresence.append(.systemGreen)
                        }
                        else if imageName == "doch-neomluven" {
                            seminarPresence.append(.red)
                        }
                        else if imageName == "doch-omluven" {
                            seminarPresence.append(.purple)
                        }
                        else if imageName == "doch-pozde" {
                            seminarPresence.append(.midnightBlue)
                        }
                        else if imageName == "doch-vyloucen" {
                            seminarPresence.append(.black)
                        }
                        else if imageName == "bullet-j" {
                            seminarPresence.append(.orange)
                        }
                        else {
                            seminarPresence.append(.lightGray)
                        }
                    }
                    let eIndexSubject = EIndexSubject(subjectName: name, sylabus: sylabus, files: files, tests: tests, sheets: sheets, seminarPresence: seminarPresence)
                    EIndexSubject.sharedInstance.arrayOfSubjects.append(eIndexSubject)
                }
                else {
                    var presence = [UIColor]()
                    let allWeeks = allRows.get(n)
                    let column = try allWeeks.select("td")
                    print("Pocet presence")
                    print(column.count)
                    if !column.isEmpty() {
                        for i in 1..<column.count {
                            var images = try column.get(i).select("span > img")
                            if images.isEmpty() {
                                images = try column.get(i).select("div > img")
                            }
                            let imageName = try images.attr("sysid")
                            
                            if imageName == "bullet-d" {
                                presence.append(.blue)
                            }
                            else if imageName == "doch-pritomen" {
                                presence.append(.systemGreen)
                            }
                            else if imageName == "doch-neomluven" {
                                presence.append(.red)
                            }
                            else if imageName == "doch-omluven" {
                                presence.append(.purple)
                            }
                            else if imageName == "doch-pozde" {
                                presence.append(.midnightBlue)
                            }
                            else if imageName == "doch-vyloucen" {
                                presence.append(.black)
                            }
                            else if imageName == "bullet-j" {
                                presence.append(.orange)
                            }
                            else {
                                presence.append(.lightGray)
                            }
                        }
                    }
                    EIndexSubject.sharedInstance.arrayOfSubjects.last?.presence = presence
                }
            }
        }
        catch {
            print("Error")
        }
    }
    
//    MARK: Parse marks
    func getMarks(html: String) {
        let array = EIndexSubject.sharedInstance.arrayOfSubjects
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(html) else { return }
            
            let table = try doc.select("table#tmtab_1")
            let rows = try table.select("tbody > tr")
            
            for n in 0..<rows.count {
                let actualRow = rows.get(n)
                var mark = try actualRow.select("td:nth-child(7)").text()
                if mark.isEmpty {
                    array[n].subjectMark = "-"
                }
                else {
                    mark = stringparser.suffixWithoutVal(value: "(", string: mark)
                    mark = stringparser.prefixWithoutVal(value: ")", string: mark)
                    array[n].subjectMark = mark
                }
            }
            
        }
        catch {
            print("error")
        }
    }
    
//    MARK: Parse semesters
    func getSemesters(html: String) {
        Semester.sharedInstance.arrayOfSemesters.removeAll()
        do {
            guard let doc: Document = try? SwiftSoup.parse(html) else { return }
            let studies = try doc.select("[name=studium]")

//            MARK: Load all studies
            if !studies.isEmpty() {
                let options = try studies.get(0).select("option")
                if !options.isEmpty() {
                    for option in options {
                        let value = try option.val()
                        let name = try option.text()
//                        from [sem 5, roc 3] get number of semesters
                        var countOfSemesters = stringparser.suffixWithoutVal(value: "[", string: name)
                        countOfSemesters = stringparser.prefixWithoutVal(value: ",", string: countOfSemesters)
                        countOfSemesters = stringparser.suffixWithoutVal(value: " ", string: countOfSemesters)
//                        add object to array
                        let studiesObject = Studies(name: name, id: value, count: Int(countOfSemesters)!)
                        Studies.sharedInstance.arrayOfStudies.append(studiesObject)
                    }
                }
            }
            
            let elements = try doc.select("[name=obdobi]")
            
//            MARK: Load all semesters
            if !elements.isEmpty() {
                let options = try elements.get(0).select("option")
                let selected = try elements.get(0).select("[selected]")
                Semester.sharedInstance.actualSemester = try selected.text()
        
                Semester.sharedInstance.actualSemester = stringparser.prefixWithoutVal(value: "-", string: Semester.sharedInstance.actualSemester)
                if !options.isEmpty(){
                    for option in options {
                        let value = try option.val()
                        var name = try option.text()
                        name = stringparser.prefixWithoutVal(value: "-", string: name)
                        let years = stringparser.suffixWithoutVal(value: " ", string: name)
                        let semesterObject = Semester(name: name, id: value, years: years)
                        Semester.sharedInstance.arrayOfSemesters.append(semesterObject)
                    }
                }
                
                Semester.sharedInstance.arrayOfSemesters = Semester.sharedInstance.arrayOfSemesters.sorted(by: { $0.years < $1.years })

                
                if !Studies.sharedInstance.arrayOfStudies.isEmpty {
                    var tmp = 0
                    for n in 0..<Studies.sharedInstance.arrayOfStudies.count {
                        for i in 0..<Semester.sharedInstance.arrayOfSemesters.count {
                            if i < Studies.sharedInstance.arrayOfStudies[n].countOfSemesters {
                                Semester.sharedInstance.arrayOfSemesters[tmp].studiesId = Studies.sharedInstance.arrayOfStudies[n].id
                            }
                            else { break }
                            tmp = tmp + 1
                        }
                    }
                }
            }
//             MARK: If semester element is hide
            else {
                let semesterObject = Semester(name: "", id: "", years: "")
                Semester.sharedInstance.arrayOfSemesters.append(semesterObject)
                Semester.sharedInstance.actualSemester = getXPathvalue(xPath: "/html/body/div[2]/div/div/form/div[1]/div/b[2]", fromHtml: html)
                Semester.sharedInstance.actualSemester = stringparser.prefixWithoutVal(value: "-", string: Semester.sharedInstance.actualSemester)
            }
        }
        catch {
            print("Error")
        }
    }
    
//    MARK: Get Emails
    func getEmails(html: String) -> Array<Email>{
        var emails = [Email]()
        var time = String()
        var date = String()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(html) else { return emails}
            let rows = try doc.select("#tmtab_1 > tbody > tr")
            
            if rows.count > 0 {
                for n in 0...rows.count - 1 {
                    // Get the name of sender
                    let name = try rows.get(n).select("tr > td:nth-child(4)").text()
                    
                    //Get subject of email
                    let subjectColumn = try rows.get(n).select("tr > td:nth-child(5)")
                    var clearedSubject = try subjectColumn.select("div, span").tagName("a").html()
                    clearedSubject = clearedSubject.replacingOccurrences(of: "&nbsp;", with: " ")
                    //Lot of &nbsp; making problems with library
                    guard let subjectDocument: Document = try? SwiftSoup.parse(clearedSubject) else {return emails}
                    let subject = try subjectDocument.select("a").attr("title")
                    var link = try subjectDocument.select("a").attr("href")
                    link = stringparser.suffixWithoutVal(value: ".", string: link)
                    
                    let getUnread = try subjectDocument.select("a > b")
                    var unread = false
                    if !getUnread.isEmpty() {
                        unread = true
                    }
                    
                    let attachmentColumn = try rows.get(n).select("tr > td:nth-child(2)")
                    let attachment = try attachmentColumn.select("span, div").html()
                    var isAttachment = false
                    if attachment.contains("posta-sponka1_16") {
                        isAttachment = true
                    }
                    
                    let dateColumn = try rows.get(n).select("tr > td:nth-child(6)")
                    let timeAndDate = try dateColumn.select("span, div").text()
                    if !timeAndDate.contains("KiB") || !timeAndDate.isEmpty {
                        (date, time) = stringparser.getDate(string: timeAndDate)
                    }
                    else {
                        date = ""
                        time = ""
                    }
                    let emailObject = Email(subject: subject, name: name, date: date, time: time, link: link, unread: unread, attachment: isAttachment)
                    emails.append(emailObject)
                }
            }
        }
        catch {
            print("Error")
        }
        
        return emails
    }
    
    func getCountOfEmails(fromHtml: String) -> Int {
        var countOfEmails = Int()
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return 0 }
            let mainTable = try doc.select("table[width=100%] > tbody > tr:nth-child(1)")
            if !mainTable.isEmpty() {
                let filterTables = mainTable.last()
                if filterTables != nil {
                    var count = try filterTables!.select("td > span").text()
                    count = stringparser.suffixWithoutVal(value: "všetkých ", string: count)
                    count = stringparser.prefixWithoutVal(value: " ", string: count)
                    count = count.trimmingCharacters(in: .whitespaces)
                    countOfEmails = Int(count) ?? 0
                    print(countOfEmails)
                }
            }   
        }
        catch {
            print("Error")
        }
        return countOfEmails
    }
    
    //    MARK: Load Files
    func getFiles(fromHtml: String) {
        Files.sharedInstance.arrayOfFiles.removeAll()
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return }
            
            var tables = try doc.select("form[name=wqqwqqwwqyw0] > #tmtab_1")

            if tables.isEmpty() {
                tables = try doc.select("form[name=wqqwqqwwqyw0] > table")
            }

            
            let table = tables.last()
            if table != nil {
                
                let rows = try table!.select("tbody > tr")
                let columns = try rows.select("td")
                
                if columns.count > 1 {
                    if rows.count != 0 {
                        for n in 0..<rows.count {
                            var isPDF = Bool()
                            let actualRow = rows.get(n)
                            var type = try actualRow.select("td:nth-child(10) > div > a > img").attr("sysid")
                            if type.isEmpty {
                                type = try actualRow.select("td:nth-child(10) > span > a > img").attr("sysid")
                            }
                            
                            if (type == "mime-pdf") {
                                isPDF = true
                            }
                            else {
                                isPDF = false
                            }
                            
                            var fileLink = try actualRow.select("td:nth-child(10) > div > a").attr("href")
                            if fileLink.isEmpty {
                                fileLink = try actualRow.select("td:nth-child(10) > span > a ").attr("href")
                            }
                            var fileName = try actualRow.select("td:nth-child(2) > div").text()
                            if fileName.isEmpty {
                                fileName = try actualRow.select("td:nth-child(2) > span").text()
                            }
                            
                            let file = Files(fileName: fileName, fileDownload: fileLink, folder: false, isPDF: isPDF)
                            Files.sharedInstance.arrayOfFiles.append(file)
                        }
                    }
                }
                else {
                    let rows = try doc.select("form[name=wqqwqqwwqyw1] > table > tbody > tr")
                    let columns = try rows.select("td")
                    
                    if columns.count > 1 {
                        if rows.count != 0 {
                            for n in 0..<rows.count {
                                
                                var fileName = try rows.get(n).select("td:nth-child(2) > div").text()
                                if fileName.isEmpty {
                                    fileName = try rows.get(n).select("td:nth-child(2) > span").text()
                                }
                                
                                var fileLink = try rows.get(n).select("td:nth-child(6) > div > a").attr("href")
                                if fileLink.isEmpty {
                                    fileLink = try rows.get(n).select("td:nth-child(6) > span > a").attr("href")
                                }
                            
                                let file = Files(fileName: fileName, fileDownload: fileLink, folder: true, isPDF: false)
                                Files.sharedInstance.arrayOfFolderFiles.append(file)
                            }
                        }
                    }
                }
            }
        }
        catch {
            print("Error")
        }
    }
    
    func getSerialCodeWifi(fromHtml: String) -> String? {
        var serialCode = String()
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return nil}
            let serialInput = try doc.select("input[name=serial]")
            serialCode = try serialInput.get(0).val()
        }
        catch {
            print("Error")
        }
        return serialCode
    }
    
//     MARK: Get Sheets
    func getSheets(fromHtml: String) -> Array<SheetsTable>?{
        var array = [SheetsTable]()
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return nil }

            let allTables = try doc.select("form > table") // Get all tables
            for i in 0..<allTables.count {
                if allTables.get(i).children().count == 2 { // Filter out only tables with 2 children - our tables
                    
                    let table = allTables.get(i)
                    var dictionary = [KeyValue]()
                    dictionary.append(KeyValue(key: "nil", value: "nil"))
                    
                    let rowsInHead = try table.select("thead > tr")
                    let rowsInContent = try table.select("tbody > tr")
                    
                    if rowsInContent.count > 1 { // When it has more than one row, it has note in it
                        let columns = try rowsInHead.get(0).select("th")
                        let values = try rowsInContent.get(0).select("td")
//                        let notes = try rowsInContent.get(1).select("td")
                        
                        for n in 0..<columns.count {
                            let key = try columns.get(n).text()
                            let value = try values.get(n).text()
                            let keyValue = KeyValue(key: key, value: value)
                            dictionary.append(keyValue)
                        }
                        
//                        let getNote = try notes.get(1).text()
                    }
                    else { // Without note, we know that table has only 2 rows
                        let columns = try rowsInHead.get(0).select("th")
                        let values = try rowsInContent.get(0).select("td")
                        
                        for n in 0..<columns.count {
                            let key = try columns.get(n).text()
                            let value = try values.get(n).text()
                            let keyValue = KeyValue(key: key, value: value)
                            dictionary.append(keyValue)
                        }
                    }
                    
                    var previousTag = try table.previousElementSibling()
                    var titleName = String()
                    
                    while titleName.isEmpty {
                        if previousTag?.tagName() == "b" {
                            titleName = try previousTag!.text()
                        }
                        else if previousTag?.tagName() == "p" {
                            titleName = try previousTag!.select("b").text()
                        }
                        else {
                            previousTag = try previousTag?.previousElementSibling()
                        }
                    }
                    
                    let sheetsTable = SheetsTable(name: titleName, dictionary: dictionary)
                    array.append(sheetsTable)
                }
            }
        }
        catch {
            print("Error")
        }
        return array
    }
    
    func getPersonalData(fromHtml: String) -> Array<KeyValue>? {
        var array = [KeyValue]()
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return nil}
            let rows = try doc.select("#tmtab_1 > tbody > tr")
            
            for i in 0..<rows.count {
                let key = try rows.get(i).select("td:nth-child(1)").text()
                let value = try rows.get(i).select("td:nth-child(2)").text()
                let keyValue = KeyValue(key: key, value: value)
                array.append(keyValue)
            }
        }
        catch {
            print("Error")
        }
        
        return array
    }
    
    func getNewPassword(html: String) -> String? {
        var newPassword = String()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(html) else { return nil}
            var table = try doc.select("form > table > tbody > tr:nth-child(2) > td > span > b")
            if table.isEmpty() {
                table = try doc.select("form > table > tbody > tr:nth-child(2) > td > div > b")
            }
            newPassword = try table.text()
            
        }
        catch {
            print("Error")
        }
        
        return newPassword
    }
    
    func getNewWifiName(html: String) -> String? {
        var newName = String()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(html) else { return nil}
            var table = try doc.select("form > table > tbody > tr:nth-child(1) > td > span > b")
            if table.isEmpty() {
                table = try doc.select("form > table > tbody > tr:nth-child(1) > td > div > b")
            }
            newName = try table.text()
            
        }
        catch {
            print("Error")
        }
        
        return newName
    }
    
    func getPersonDetails(fromHtml: String) -> (String?, String?) {
        var emailIn = String()
        var emailOut = String()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return (nil, nil) }
            let links = try doc.select("table a[href]")
            var emails : [String] = []
            for i in 0..<links.count {
                let isEmail = try links.get(i).text().contains("[at]")
                let address = try links.get(i).text()
                if isEmail {
                    emails.append(address.replacingOccurrences(of: " [at] ", with: "@"))
                }
            }
            if emails.count > 0 {
                if let firstEmail = emails.first {
                    emailIn = firstEmail
                }
                if let lastEmail = emails.last {
                    if lastEmail != emailIn {
                        emailOut = lastEmail
                    }
                }
            }
            
        }
        catch {
            print("Error")
        }
        
        return (emailIn, emailOut)
    }
//    MARK: Mailboxes
    func getMailboxes(fromHtml: String) -> Array<Mailbox>? {
        var array = [Mailbox]()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return nil }
            let allMailboxes = try doc.select("div.tree > ul > li")
            
            for n in 1..<allMailboxes.count {
                var name = try allMailboxes.get(n).select("div > div.node-icon-container > div.node-label").text()
                let id = try allMailboxes.get(n).select("div.node-container").attr("id")
                let count = stringparser.suffixWithVal(value: "(", string: name)
                name = stringparser.prefixWithoutVal(value: "(", string: name)
                name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                let mailbox = Mailbox(name: name, id: id, count: count)
                array.append(mailbox)
            }
        }
        catch {
            print("Error")
        }
        
        return array
    }
//    MARK: Get trash link
    func getTrash(fromHtml: String) -> String? {
        var trashLink = String()
        
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return nil }
            let trash = try doc.select("a[onclick^=vysypat_kos]")
            if trash.count > 0 {
                trashLink = try trash.get(0).attr("href")
            }
        }
        catch {
            print("Error")
        }
        return trashLink
    }
    
//    MARK: Places
    func getPlacesTables(fromHtml: String) -> Array<PlacesTables>? {
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else {
                return nil}
            
            let tables = try doc.select("form > table > thead + tbody")
            var arrayOfTables = [PlacesTables]()
            if tables.count > 0 {
                for i in 0..<tables.count - 1 {
                    let rows = try tables.get(i).select("tbody > tr")
                    
                    
                    if rows.count > 0 {
                        let columns = try rows.get(0).select("tr > td")
                        print("Count of columns: \(columns.count)")
                        var arrayOfPlaces = [Places]()
                        var isReminder = Bool()
                        let firstElement = Places(name: "", subject: "", date: "", time: "", teacher: "", detail: "", isOpened: nil, points: nil)
                        arrayOfPlaces.append(firstElement)
                        var nameOfTable = String()
                        
                        if columns.count == 11 {
                            nameOfTable = "Kam môžem odovzdať"
                            for n in 0..<rows.count {
                                let row = rows.get(n)
                                let subjectColum = try row.select("tr > td:nth-child(1)")
                                var subject = try subjectColum.select("div > a").text()
                                if subject.isEmpty {
                                    subject = try subjectColum.select("span > a").text()
                                }
                                subject = stringparser.suffixWithoutVal(value: " ", string: subject)
                                
                                let nameColumn = try row.select("tr > td:nth-child(2)")
                                let name = try nameColumn.select("span, div").text()
                                
                                let endDateColumn = try row.select("tr > td:nth-child(5)")
                                var endDate = try endDateColumn.select("span, div").text()
                                endDate = endDate.replacingOccurrences(of: ". ", with: ".")
                                
                                let detailColumn = try row.select("tr > td:nth-child(9)")
                                var detail = try detailColumn.select("div > a").attr("href")
                                if detail.isEmpty {
                                    detail = try detailColumn.select("span > a").attr("href")
                                }
                                
                                let teacherColumn = try row.select("tr > td:nth-child(10)")
                                var teacher = try teacherColumn.select("div > a").text()
                                if teacher.isEmpty {
                                    teacher = try teacherColumn.select("span > a").text()
                                }
                                
                                let date = stringparser.prefixWithoutVal(value: " ", string: endDate)
                                let time = stringparser.suffixWithoutVal(value: " ", string: endDate)
                                
                                let placesObject = Places(name: name, subject: subject, date: date, time: time, teacher: teacher, detail: detail, isOpened: nil, points: nil)
                                arrayOfPlaces.append(placesObject)
                                isReminder = true
                            }
                        }
                        else if columns.count == 13 {
                            nameOfTable = "Miesta odovzdania s odovzdanými súbormi"
                            for n in 0..<rows.count {
                                let row = rows.get(n)
                                
                                let subjectColumn = try row.select("tr > td:nth-child(1)")
                                var subject = try subjectColumn.select("div > a").text()
                                if subject.isEmpty {
                                    subject = try subjectColumn.select("span > a").text()
                                }
                                subject = stringparser.suffixWithoutVal(value: " ", string: subject)
                                
                                let nameColumn = try row.select("tr > td:nth-child(2)")
                                let name = try nameColumn.select("span, div").text()
                                
                                let endDateColumn = try row.select("tr > td:nth-child(5)")
                                var endDate = try endDateColumn.select("span, div").text()
                                endDate = endDate.replacingOccurrences(of: ". ", with: ".")
                                let date = stringparser.prefixWithoutVal(value: " ", string: endDate)
                                let time = stringparser.suffixWithoutVal(value: " ", string: endDate)
                                
                                let openedColumn = try row.select("tr > td:nth-child(7)")
                                var opened = try openedColumn.select("div > img").attr("sysid")
                                if opened.isEmpty {
                                    opened = try openedColumn.select("span > img").attr("sysid")
                                }
                                var isOpened = Bool()
                                if opened == "bullet-green-big-new" {
                                    isOpened = true
                                }
                                else {
                                    isOpened = false
                                }
                                
                                let pointsColumn = try row.select("tr > td:nth-child(8)")
                                let points = try pointsColumn.select("span, div").text()
                                
                                let detailColumn = try row.select("tr > td:nth-child(13)")
                                var detail = try detailColumn.select("span > a").attr("href")
                                if detail.isEmpty {
                                    detail = try detailColumn.select("div > a").attr("href")
                                }
                                
                                let teacherColumn = try row.select("tr > td:nth-child(12)")
                                var teacher = try teacherColumn.select("span > a").text()
                                if teacher.isEmpty {
                                    teacher = try teacherColumn.select("div > a").text()
                                }
                                
                                let placesObject = Places(name: name, subject: subject, date: date, time: time, teacher: teacher, detail: detail, isOpened: isOpened, points: points)
                                arrayOfPlaces.append(placesObject)
                                isReminder = false
                            }
                        }
                        
                        let placesTablesObject = PlacesTables(name: nameOfTable, array: arrayOfPlaces, reminders: isReminder)
                        arrayOfTables.append(placesTablesObject)
                    }
                }
            }
            return arrayOfTables
        }
        catch {
            print("Error")
        }
        
        return nil
    }
    
    func getUserName(fromHtml: String) -> String? {
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return nil }
            var userName = try doc.select("div#log").text()
            userName = self.stringparser.suffixWithoutVal(value: ":", string: userName)
            userName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
            print("TOTO JE MENO")
            print(userName)
            return userName
        }
        catch {
            print("error")
        }
        
        return nil
    }
    
    func getUserID(fromHtml: String) -> String? {
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else { return nil }
            let tables = try doc.select("form > table")
            let studyTable = tables.get(1)
            let id = try studyTable.select("tbody > tr:nth-child(1) > td:nth-child(2)").text()
            return id
            
        }
        catch {
            print("error")
        }
        
        return nil
    }
//      MARK: Tests
    func getTests(fromHtml: String) -> Array<Tests>? {
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else {return nil}
            let tables = try doc.select("form > table > thead + tbody")
            if tables.count > 0 {
                let rows = try tables.get(0).select("tbody > tr")
                if rows.count > 0 {
                    var arrayOfTests = [Tests]()
                    for n in 0..<rows.count {
                        let row = rows.get(n)
                        let name = try row.select("tr > td:nth-child(1)").text()
                        var isShowing = try row.select("tr > td:nth-child(4) > div > i")
                        if isShowing.isEmpty() {
                            isShowing = try row.select("tr > td:nth-child(4) > span > i")
                        }
                        
                        if isShowing.count > 0 {
                            let test = Tests(testName: name, allPoints: "", remainingPoints: "")
                            arrayOfTests.append(test)
                        }
                        else {
                            let pointsRemains = try row.select("tr > td:nth-child(4)").text()
                            let allPoints = try row.select("tr > td:nth-child(5)").text()
                            
                            let test = Tests(testName: name, allPoints: allPoints, remainingPoints: pointsRemains)
                            arrayOfTests.append(test)
                        }
                        
                        
                    }
                    return arrayOfTests
                }
            }
        }
        catch {
            print("error")
        }
        return nil
    }
    
//    MARK: Places upload date
    func getUploadDate(fromHtml: String) -> String? {
        var uploadDate : String?
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else {return nil}
            let tmp = try doc.select("form div, span")
            var getDate = try tmp.select("div > div, span > b")
            if getDate.isEmpty() {
                getDate = try tmp.select("span > div, span > b")
            }
            
            for n in 0..<getDate.count {
                let numbRange = try getDate.get(n).text().rangeOfCharacter(from: .decimalDigits)
                if numbRange != nil {
                    uploadDate = try getDate.get(n).text()
                }
            }
            
            return uploadDate
        
        }
        catch {
            print("Error")
        }
        return nil
    }
    
//    MARK: Get uploaded files
    func getUploadedFiles(fromHtml: String) -> Array<UploadedFiles>? {
        var array = [UploadedFiles]()
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else {return nil}
            let tables = try doc.select("form > table")
            let table = tables.last()
            if table != nil {
                let rows = try table!.select("tbody > tr")
                if !rows.isEmpty() {
                    for n in 0..<rows.count{
                        let row = rows.get(n)
                        let name = try row.select("td:nth-child(1)").text()
                        let tmp = try row.select("td:nth-child(2)")
                        var link = try tmp.select("span > a").attr("href")
                        if link.isEmpty {
                            link = try tmp.select("div > a").attr("href")
                        }
                        let author = try row.select("td:nth-child(5)").text()
                        let uploadFile = UploadedFiles(name: name, link: link, author: author)
                        array.append(uploadFile)
                    }
                    return array
                }
            }
        }
        catch {
            print("Error")
        }
        
        return nil
    }
    
//    MARK: Get uploaded files
    func getSuccessUpload(fromHtml: String) -> Bool? {
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else {return nil}
            let bullet = try doc.select("[sysid=bullet-green-big-faja]")
            if bullet.count > 0 {
                return true
            }
        }
        catch {
            print("Error")
        }
        return nil
    }
    
    func getNameDay(fromHtml: String) -> String? {
        do {
            guard let doc: Document = try? SwiftSoup.parse(fromHtml) else {return nil}
            var nameDay = try doc.select("#svatek").text()
            nameDay = nameDay.components(separatedBy: CharacterSet.decimalDigits).joined()
            nameDay = nameDay.replacingOccurrences(of: ".", with: "")
            nameDay = nameDay.replacingOccurrences(of: ":", with: "")
            nameDay = nameDay.trimmingCharacters(in: .whitespacesAndNewlines)
            return nameDay

        }
        catch {
            print("Error")
        }
        return nil
    }
}
