# Automatic Transaction Categorization Plan

## Overview
Create an intelligent system to automatically categorize transactions from bank imports, reducing manual review time from hours to minutes.

## Categorization Approaches

### 1. Rule-Based Categorization (Phase 1 - Immediate)

#### Merchant Name Mapping
**File: `data/merchant_rules.json`**
```json
{
  "exact_matches": {
    "AMAZON.COM": "Expenses:Shopping:Online",
    "WALMART": "Expenses:Shopping:Groceries", 
    "SHELL": "Expenses:Transportation:Gas",
    "MCDONALD'S": "Expenses:Food:FastFood"
  },
  "contains_patterns": {
    "AMAZON": "Expenses:Shopping:Online",
    "GROCERY": "Expenses:Food:Groceries",
    "GAS": "Expenses:Transportation:Gas",
    "RESTAURANT": "Expenses:Food:DiningOut"
  },
  "regex_patterns": {
    "^ATM.*": "Expenses:Cash",
    ".*PAYROLL.*": "Income:Salary",
    ".*INTEREST.*": "Income:Interest"
  }
}
```

#### Amount-Based Rules
```json
{
  "amount_rules": {
    "recurring_bills": {
      "description_pattern": ".*ELECTRIC.*|.*WATER.*|.*INTERNET.*",
      "amount_range": [50, 300],
      "category": "Expenses:Housing:Utilities"
    },
    "small_purchases": {
      "amount_max": 5.00,
      "default_category": "Expenses:Food:Coffee"
    }
  }
}
```

### 2. Machine Learning Categorization (Phase 2 - Advanced)

#### Training Data Collection
- Build training dataset from manually categorized transactions
- Include features: merchant, amount, date, description
- Export existing hledger data as training set

#### ML Model Features
```python
features = {
    "merchant_name": "text_vectorization",
    "amount": "numerical",
    "day_of_week": "categorical", 
    "time_of_day": "categorical",
    "description_keywords": "text_features"
}
```

#### Model Options
1. **Random Forest** - Good for interpretable rules
2. **Naive Bayes** - Fast, works well with text
3. **Neural Network** - Best accuracy for complex patterns

### 3. Hybrid Approach (Phase 3 - Optimal)

#### Priority System
1. **Exact merchant match** (100% confidence)
2. **Regex pattern match** (95% confidence) 
3. **ML prediction** (varies by confidence score)
4. **Default category** (requires review)

## Implementation Architecture

### Core Components

#### 1. Categorization Engine
**File: `scripts/categorizer.py`**
```python
class TransactionCategorizer:
    def __init__(self):
        self.rules = self.load_rules()
        self.ml_model = self.load_model()
    
    def categorize(self, transaction):
        # Try rule-based first
        category = self.apply_rules(transaction)
        if category:
            return category, "rule_based", 1.0
            
        # Fall back to ML
        category, confidence = self.ml_predict(transaction)
        if confidence > 0.8:
            return category, "ml_prediction", confidence
            
        # Default to manual review
        return "Expenses:Other", "needs_review", 0.0
```

#### 2. Learning System
**File: `scripts/learn_categories.py`**
- Analyze user corrections to improve rules
- Retrain ML model monthly with new data
- Suggest new merchant rules automatically

#### 3. Review Interface
**File: `scripts/review_categories.py`**
- Show uncategorized transactions
- Allow batch categorization
- Learn from user decisions

## Category Structure

### Primary Categories
```
Income:
├── Salary
├── Freelance  
├── Interest
└── Other

Expenses:
├── Housing (rent, utilities, maintenance)
├── Food (groceries, restaurants, coffee)
├── Transportation (gas, maintenance, parking)
├── Healthcare (medical, pharmacy, insurance)
├── Shopping (clothes, electronics, general)
├── Entertainment (movies, subscriptions, hobbies)
├── Finance (fees, interest, taxes)
└── Other
```

### Subcategory Auto-Assignment
```python
subcategory_rules = {
    "NETFLIX|SPOTIFY|HULU": "Expenses:Entertainment:Subscriptions",
    "PHARMACY|CVS|WALGREENS": "Expenses:Healthcare:Pharmacy",
    "STARBUCKS|COFFEE": "Expenses:Food:Coffee",
    "UBER|LYFT|TAXI": "Expenses:Transportation:Rideshare"
}
```

## Confidence Scoring

### Scoring Criteria
- **1.0**: Exact merchant match or regex pattern
- **0.9-0.95**: High-confidence ML prediction
- **0.7-0.89**: Medium confidence (may need review)
- **<0.7**: Low confidence (definitely needs review)

### Auto-Apply Thresholds
- **>= 0.9**: Automatically categorize
- **0.7-0.89**: Suggest category but flag for review
- **< 0.7**: Leave uncategorized

## Learning and Improvement

### Feedback Loop
1. **User Corrections**: Track when users change categories
2. **Pattern Recognition**: Identify common correction patterns
3. **Rule Updates**: Automatically suggest new merchant rules
4. **Model Retraining**: Monthly ML model updates

### Analytics Dashboard
Track categorization performance:
- Accuracy rate by category
- Most commonly miscategorized merchants
- Time saved vs manual categorization

## Integration with Plaid Sync

### Enhanced Sync Script
**File: `scripts/enhanced_sync.py`**
```python
def process_transactions(transactions):
    categorized = []
    for transaction in transactions:
        # Get category suggestion
        category, method, confidence = categorizer.categorize(transaction)
        
        # Create hledger entry
        entry = create_hledger_entry(
            transaction, 
            category, 
            confidence_score=confidence
        )
        
        categorized.append(entry)
    
    return categorized
```

### Confidence Tags
Add confidence metadata to transactions:
```hledger
2024-01-15 * AMAZON.COM
    ; confidence: 1.0, method: rule_based
    Expenses:Shopping:Online           $50.00
    Assets:Checking:Chase
```

## Implementation Timeline

### Week 1: Rule-Based System
- [ ] Create merchant rules JSON file
- [ ] Implement basic rule engine
- [ ] Test with 100 sample transactions
- [ ] Achieve 70%+ auto-categorization rate

### Week 2: ML Foundation  
- [ ] Export existing transactions as training data
- [ ] Build simple ML classifier
- [ ] Test hybrid rule + ML approach
- [ ] Target 85%+ accuracy

### Week 3: Learning System
- [ ] Implement feedback collection
- [ ] Add confidence scoring
- [ ] Create review interface
- [ ] Auto-update merchant rules

### Month 2: Advanced Features
- [ ] Pattern recognition for new merchants
- [ ] Seasonal categorization (holidays, etc.)
- [ ] Budget-aware categorization
- [ ] Mobile review interface

## Success Metrics

### Performance Targets
- **Auto-categorization Rate**: >90% of transactions
- **Accuracy**: >95% for auto-categorized transactions  
- **Review Time**: <5 minutes daily
- **Learning Speed**: New merchants auto-categorized after 2-3 transactions

### Quality Measures
- Zero duplicate categories created
- Consistent subcategory assignment
- Proper handling of split transactions
- Accurate transfer detection

This system will dramatically reduce the time spent on transaction categorization while maintaining accuracy through continuous learning.