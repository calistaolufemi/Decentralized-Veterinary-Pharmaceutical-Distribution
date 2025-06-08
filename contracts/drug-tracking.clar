;; Drug Tracking Contract
;; Tracks veterinary pharmaceuticals through the supply chain

(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_NOT_FOUND (err u201))
(define-constant ERR_INVALID_STATUS (err u202))
(define-constant ERR_EXPIRED (err u203))

;; Drug status constants
(define-constant STATUS_MANUFACTURED u1)
(define-constant STATUS_IN_TRANSIT u2)
(define-constant STATUS_DELIVERED u3)
(define-constant STATUS_DISPENSED u4)

;; Data structures
(define-map drugs
  { drug-id: (string-ascii 50) }
  {
    name: (string-ascii 100),
    manufacturer: principal,
    batch-number: (string-ascii 50),
    manufacture-date: uint,
    expiry-date: uint,
    current-owner: principal,
    status: uint,
    temperature-range: { min: int, max: int }
  }
)

(define-map drug-history
  { drug-id: (string-ascii 50), sequence: uint }
  {
    previous-owner: principal,
    new-owner: principal,
    timestamp: uint,
    location: (string-ascii 100),
    temperature: int,
    notes: (string-ascii 200)
  }
)

(define-map drug-sequences
  { drug-id: (string-ascii 50) }
  { current-sequence: uint }
)

;; Public functions
(define-public (register-drug
  (drug-id (string-ascii 50))
  (name (string-ascii 100))
  (batch-number (string-ascii 50))
  (manufacture-date uint)
  (expiry-date uint)
  (temp-min int)
  (temp-max int)
)
  (let ((manufacturer tx-sender))
    (asserts! (is-none (map-get? drugs { drug-id: drug-id })) ERR_INVALID_STATUS)
    (asserts! (> expiry-date block-height) ERR_EXPIRED)
    (map-set drugs
      { drug-id: drug-id }
      {
        name: name,
        manufacturer: manufacturer,
        batch-number: batch-number,
        manufacture-date: manufacture-date,
        expiry-date: expiry-date,
        current-owner: manufacturer,
        status: STATUS_MANUFACTURED,
        temperature-range: { min: temp-min, max: temp-max }
      }
    )
    (map-set drug-sequences
      { drug-id: drug-id }
      { current-sequence: u0 }
    )
    (ok true)
  )
)

(define-public (transfer-drug
  (drug-id (string-ascii 50))
  (new-owner principal)
  (location (string-ascii 100))
  (temperature int)
  (notes (string-ascii 200))
)
  (match (map-get? drugs { drug-id: drug-id })
    drug-data
    (let (
      (current-sequence (default-to u0 (get current-sequence (map-get? drug-sequences { drug-id: drug-id }))))
      (new-sequence (+ current-sequence u1))
    )
      (asserts! (is-eq (get current-owner drug-data) tx-sender) ERR_UNAUTHORIZED)
      (asserts! (> (get expiry-date drug-data) block-height) ERR_EXPIRED)

      ;; Update drug ownership
      (map-set drugs
        { drug-id: drug-id }
        (merge drug-data {
          current-owner: new-owner,
          status: STATUS_IN_TRANSIT
        })
      )

      ;; Record transfer history
      (map-set drug-history
        { drug-id: drug-id, sequence: new-sequence }
        {
          previous-owner: tx-sender,
          new-owner: new-owner,
          timestamp: block-height,
          location: location,
          temperature: temperature,
          notes: notes
        }
      )

      ;; Update sequence
      (map-set drug-sequences
        { drug-id: drug-id }
        { current-sequence: new-sequence }
      )

      (ok true)
    )
    ERR_NOT_FOUND
  )
)

(define-public (update-drug-status (drug-id (string-ascii 50)) (new-status uint))
  (match (map-get? drugs { drug-id: drug-id })
    drug-data
    (begin
      (asserts! (is-eq (get current-owner drug-data) tx-sender) ERR_UNAUTHORIZED)
      (asserts! (<= new-status STATUS_DISPENSED) ERR_INVALID_STATUS)
      (map-set drugs
        { drug-id: drug-id }
        (merge drug-data { status: new-status })
      )
      (ok true)
    )
    ERR_NOT_FOUND
  )
)

;; Read-only functions
(define-read-only (get-drug-info (drug-id (string-ascii 50)))
  (map-get? drugs { drug-id: drug-id })
)

(define-read-only (get-drug-history (drug-id (string-ascii 50)) (sequence uint))
  (map-get? drug-history { drug-id: drug-id, sequence: sequence })
)

(define-read-only (get-current-sequence (drug-id (string-ascii 50)))
  (map-get? drug-sequences { drug-id: drug-id })
)

(define-read-only (is-drug-expired (drug-id (string-ascii 50)))
  (match (map-get? drugs { drug-id: drug-id })
    drug-data (>= block-height (get expiry-date drug-data))
    true
  )
)
