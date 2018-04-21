//
//  NotesListViewController.swift
//  notebook
//
//  Created by Павел Кошара on 24/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

private let noteCellIdentifier = "noteCell"
private let collectionSectionInset: CGFloat = 16
private let collectionRowHeight: CGFloat = 120

class NotesListViewController: UIViewController {
    @IBOutlet private weak var notesCollectionView: UICollectionView!
    @IBOutlet private weak var elementWidthSlider: UISlider!
    
    public var notesProvider: NoteProviding!
    
    private let oneInRowLayout = UICollectionViewFlowLayout()
    private let twoInRowLayout = UICollectionViewFlowLayout()
    private let threeInRowLayout = UICollectionViewFlowLayout()
    private var editMode = false
    private var notes = [Note]()
    private var editingCellIndex: IndexPath?
    
    @IBAction func elementWidthSliderValueChanged(_ slider: UISlider) {
        setCellsLayout()
    }
    
    @IBAction func editDidTap(_ sender: Any) {
        toggleEditMode()
    }
    
    @IBAction func unwindToNotesList(sender: UIStoryboardSegue) {
        let cellIndex = editingCellIndex
        editingCellIndex = nil
        
        guard let sourceViewController = sender.source as? EditViewController,
             let note = sourceViewController.getNote() else {
            return
        }
        
        if let cellIndex = cellIndex {
            notes[cellIndex.item] = note
            notesCollectionView.reloadItems(at: [cellIndex])
        } else {
            notes.append(note)
            let index = IndexPath(item: notes.count - 1, section: 0)
            notesCollectionView.insertItems(at: [index])
        }
        
        notesProvider.saveNote(note, callback: nil)
    }
    
    @objc func doneDidTap(_ sender: Any) {
        toggleEditMode()
    }

    @IBAction func addDidTap(_ sender: Any) {
        performSegue(withIdentifier: "showEditView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showEditView",
            let destintaion = segue.destination as? EditViewController,
            let index = editingCellIndex?.item else {
            return
        }
        
        destintaion.setNote(notes[index])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesCollectionView.dataSource = self
        notesCollectionView.register(
            UINib(nibName: "NoteCollectionViewCell", bundle: Bundle.main),
            forCellWithReuseIdentifier: noteCellIdentifier)
        
        [oneInRowLayout, twoInRowLayout, threeInRowLayout].forEach {
            $0.sectionInset.bottom = collectionSectionInset
            $0.sectionInset.left = collectionSectionInset
            $0.sectionInset.right = collectionSectionInset
            $0.sectionInset.top = collectionSectionInset
        }
        
        twoInRowLayout.itemSize = CGSize(
            width: (notesCollectionView.frame.width - collectionSectionInset * 2) * 0.45,
            height: collectionRowHeight)
        
        threeInRowLayout.itemSize = CGSize(
            width: (notesCollectionView.frame.width - collectionSectionInset * 2) * 0.3,
            height: collectionRowHeight)
        
        setCellsLayout()
        
        notesProvider.getAll { (notes) in
            if let notes = notes {
                self.notes = Array(notes.values)
                DispatchQueue.main.async { [unowned self] in
                    self.notesCollectionView.reloadData()
                }
            }
        }
    }
    
    private func setCellsLayout() {
        let sliderValue = CGFloat(elementWidthSlider.value)
        let currentLayout = notesCollectionView.collectionViewLayout
        
        if (sliderValue > 0.5) {
            let widthHalf = (notesCollectionView.frame.width - collectionSectionInset * 2) / 2
            oneInRowLayout.itemSize = CGSize(
                width: widthHalf + widthHalf * ((sliderValue - 0.5) / 0.5),
                height: collectionRowHeight)
            if (currentLayout != oneInRowLayout) {
                notesCollectionView.setCollectionViewLayout(oneInRowLayout, animated: true)
            }
        } else if (sliderValue > 0.25) {
            if (currentLayout != twoInRowLayout) {
                notesCollectionView.setCollectionViewLayout(twoInRowLayout, animated: true)
            }
        } else {
            if (currentLayout != threeInRowLayout) {
                notesCollectionView.setCollectionViewLayout(threeInRowLayout, animated: true)
            }
        }
    }
    
    private func toggleEditMode() {
        editMode = !editMode
        notesCollectionView.reloadItems(at: notesCollectionView.indexPathsForVisibleItems)
        if (editMode) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(doneDidTap))
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(editDidTap))
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addDidTap))
        }
    }
}

extension NotesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: noteCellIdentifier,
            for: indexPath) as! NoteCollectionViewCell
        let note = notes[indexPath.item]
        
        cell.color = note.color.cgColor
        cell.label = note.title
        cell.text = note.content
        cell.editMode = editMode
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
}

extension NotesListViewController: NoteCollectionViewCellDeletgate {
    func didTap(indexPath: IndexPath) {
        if (editMode) {
            let deletedNote = notes.remove(at: indexPath.item)
            notesProvider.removeNote(withUid: deletedNote.uid, callback: nil)
            notesCollectionView.performBatchUpdates({
                notesCollectionView.deleteItems(at: [indexPath])
            }, completion: { (finished) in
                self.notesCollectionView.reloadItems(
                    at: self.notesCollectionView.indexPathsForVisibleItems)
            })
        } else {
            editingCellIndex = indexPath
            performSegue(withIdentifier: "showEditView", sender: self)
        }
    }
}
