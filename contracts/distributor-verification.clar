;; Distributor Verification Contract
;; Manages verification and registration of veterinary pharmaceutical distributors

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VERIFIED (err u101))
(define-constant ERR_NOT_FOUND (err u102))
(define-constant ERR_INVALID_LICENSE (err u103))

;; Data structures
(define-map distributors
  { distributor-id: principal }
  {
    license-number: (string-ascii 50),
    company-name: (string-ascii 100),
    verified: bool,
    verification-date: uint,
    expiry-date: uint
  }
)

(define-map distributor-stats
  { distributor-id: principal }
  {
    total-shipments: uint,
    successful-deliveries: uint,
    rating: uint
  }
)

;; Public functions
(define-public (register-distributor (license-number (string-ascii 50)) (company-name (string-ascii 100)) (expiry-date uint))
  (let ((distributor-id tx-sender))
    (asserts! (is-none (map-get? distributors { distributor-id: distributor-id })) ERR_ALREADY_VERIFIED)
    (asserts! (> expiry-date block-height) ERR_INVALID_LICENSE)
    (map-set distributors
      { distributor-id: distributor-id }
      {
        license-number: license-number,
        company-name: company-name,
        verified: false,
        verification-date: u0,
        expiry-date: expiry-date
      }
    )
    (map-set distributor-stats
      { distributor-id: distributor-id }
      {
        total-shipments: u0,
        successful-deliveries: u0,
        rating: u0
      }
    )
    (ok true)
  )
)

(define-public (verify-distributor (distributor-id principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? distributors { distributor-id: distributor-id })
      distributor-data
      (begin
        (map-set distributors
          { distributor-id: distributor-id }
          (merge distributor-data { verified: true, verification-date: block-height })
        )
        (ok true)
      )
      ERR_NOT_FOUND
    )
  )
)

(define-public (update-distributor-stats (distributor-id principal) (shipments uint) (deliveries uint))
  (begin
    (asserts! (is-verified distributor-id) ERR_UNAUTHORIZED)
    (match (map-get? distributor-stats { distributor-id: distributor-id })
      current-stats
      (let ((new-rating (if (> shipments u0) (/ (* deliveries u100) shipments) u0)))
        (map-set distributor-stats
          { distributor-id: distributor-id }
          {
            total-shipments: shipments,
            successful-deliveries: deliveries,
            rating: new-rating
          }
        )
        (ok true)
      )
      ERR_NOT_FOUND
    )
  )
)

;; Read-only functions
(define-read-only (is-verified (distributor-id principal))
  (match (map-get? distributors { distributor-id: distributor-id })
    distributor-data (get verified distributor-data)
    false
  )
)

(define-read-only (get-distributor-info (distributor-id principal))
  (map-get? distributors { distributor-id: distributor-id })
)

(define-read-only (get-distributor-stats (distributor-id principal))
  (map-get? distributor-stats { distributor-id: distributor-id })
)
