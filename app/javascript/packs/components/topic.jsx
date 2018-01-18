import React from 'react';
import StatementSet from './statementSet.jsx';

export default class Topic extends React.Component {
  constructor(props){
    super(props)
    this.state = {
      activeStatementSetId: null,
    }
  }

  selectStatementSet(id) {
    this.setState({
      activeStatementSetId: id
    })
  }

  resetStatementSet() {
    this.setState({
      activeStatementSetId: null
    })
  }

  render() {
    let main = null;
    if (this.state.activeStatementSetId) {
      const set = this.props.statementSets.find((set) =>
        set.id == this.state.activeStatementSetId
      );
      main = <StatementSet
        topicId={set.topic_id}
        roleId={set.role_id}
        roleName={set.role_name}
        statements={set.statements}
        resetStatementSet={() => this.resetStatementSet()}
      />
    } else {
      const statemenSets = this.props.statementSets.map((set) =>
        <div
          className={'button role-selection'}
          key={set.id}
          onClick={() => this.selectStatementSet(set.id)}>
          {set.role_name}
        </div>
      )
      main = <div>
        <div className='question active'>Als was sehen Sie sie sich am ehesten?
          {statemenSets}
        </div>
      </div>
    };

    return(
      <div>
        {main}
      </div>
    )
  }
}
