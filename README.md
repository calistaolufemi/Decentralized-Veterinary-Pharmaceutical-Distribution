# Decentralized Veterinary Pharmaceutical Distribution System

A comprehensive blockchain-based system for managing veterinary pharmaceutical distribution, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides a decentralized solution for tracking, verifying, and managing veterinary pharmaceuticals throughout the supply chain. It ensures transparency, authenticity, and compliance in the distribution of veterinary drugs from manufacturers to end users.

## Features

### 🏢 Distributor Verification
- Register and verify pharmaceutical distributors
- Track distributor performance and ratings
- Manage distributor licenses and certifications

### 💊 Drug Tracking
- Complete supply chain tracking from manufacture to dispensing
- Temperature monitoring and cold chain compliance
- Batch-level traceability with immutable history

### 📋 Prescription Verification
- Veterinarian registration and verification
- Digital prescription issuance and validation
- Prescription usage tracking and compliance

### 📦 Inventory Management
- Real-time inventory tracking across locations
- Stock level alerts and automated reordering
- Transfer management between distributors and pharmacies

### ⏰ Expiration Monitoring
- Automated expiration date tracking
- Early warning alerts for near-expiry drugs
- Compliant disposal tracking and documentation

## Smart Contracts

### 1. Distributor Verification Contract (\`distributor-verification.clar\`)
Manages the registration and verification of veterinary pharmaceutical distributors.

**Key Functions:**
- \`register-distributor\`: Register a new distributor
- \`verify-distributor\`: Verify a registered distributor
- \`update-distributor-stats\`: Update performance statistics
- \`is-verified\`: Check verification status

### 2. Drug Tracking Contract (\`drug-tracking.clar\`)
Tracks veterinary pharmaceuticals through the entire supply chain.

**Key Functions:**
- \`register-drug\`: Register a new drug batch
- \`transfer-drug\`: Transfer ownership with location tracking
- \`update-drug-status\`: Update drug status in supply chain
- \`get-drug-history\`: Retrieve complete drug history

### 3. Prescription Verification Contract (\`prescription-verification.clar\`)
Manages veterinary prescriptions and their verification.

**Key Functions:**
- \`register-veterinarian\`: Register a veterinarian
- \`issue-prescription\`: Issue a new prescription
- \`dispense-prescription\`: Record prescription dispensing
- \`is-prescription-valid\`: Validate prescription status

### 4. Inventory Management Contract (\`inventory-management.clar\`)
Manages drug inventory across different locations.

**Key Functions:**
- \`initialize-inventory\`: Set up inventory for a location
- \`update-stock\`: Update stock levels
- \`transfer-stock\`: Transfer stock between locations
- \`reserve-stock\`: Reserve stock for orders

### 5. Expiration Monitoring Contract (\`expiration-monitoring.clar\`)
Monitors drug expiration dates and manages disposal.

**Key Functions:**
- \`register-batch-expiry\`: Register batch expiration information
- \`check-expiration-status\`: Check and alert on expiration status
- \`dispose-expired-batch\`: Record proper disposal of expired drugs

## Installation

### Prerequisites
- Node.js (v16 or higher)
- Clarinet CLI
- Stacks Wallet

### Setup

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd vet-pharma-distribution
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Initialize Clarinet project:
   \`\`\`bash
   clarinet new vet-pharma-distribution
   \`\`\`

4. Deploy contracts to local testnet:
   \`\`\`bash
   clarinet deploy --testnet
   \`\`\`

## Testing

Run the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

Individual test files:
- \`tests/distributor-verification.test.js\`
- \`tests/drug-tracking.test.js\`
- \`tests/prescription-verification.test.js\`
- \`tests/inventory-management.test.js\`
- \`tests/expiration-monitoring.test.js\`

## Usage Examples

### Registering a Distributor

\`\`\`clarity
(contract-call? .distributor-verification register-distributor
"VET-DIST-001"
"VetPharma Distribution Co"
u1000000)
\`\`\`

### Tracking a Drug

\`\`\`clarity
(contract-call? .drug-tracking register-drug
"AMOX-001"
"Amoxicillin 500mg"
"BATCH-2024-001"
u1000
u2000
2
8)
\`\`\`

### Issuing a Prescription

\`\`\`clarity
(contract-call? .prescription-verification issue-prescription
"RX-001"
"John Smith"
"Canine"
"Amoxicillin"
"500mg twice daily"
u14
u2000)
\`\`\`

## Security Considerations

- All contracts implement proper access controls
- Distributor verification requires authorized approval
- Prescription issuance limited to verified veterinarians
- Drug transfers require ownership verification
- Expiration monitoring prevents dispensing of expired drugs

## Compliance Features

- Complete audit trail for all transactions
- Regulatory reporting capabilities
- Temperature monitoring for cold chain compliance
- Proper disposal documentation for expired drugs
- Prescription tracking for controlled substances

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository or contact the development team.

## Roadmap

- [ ] Integration with IoT sensors for real-time temperature monitoring
- [ ] Mobile app for field veterinarians
- [ ] Integration with existing veterinary practice management systems
- [ ] Advanced analytics and reporting dashboard
- [ ] Multi-chain support for broader adoption
  \`\`\`

Finally, let's create the PR details file:
