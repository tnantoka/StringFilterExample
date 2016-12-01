const Source = ({ children }) => (
  <p className="form-control-static bg-faded mb-0 px-1"><code>{ children }</code></p>
)


class Example extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      example: this.props.example,
      loading: false,
    }
  }

  handleSubmit(e) {
    e.preventDefault()
    this.setState({ loading: true })
    const { example } = this.state

    const headers = new Headers()
    headers.append('Content-Type', 'application/json')
    fetch(`/examples/${example.id}`, {
      method: 'PATCH',
      headers: headers,
      body: JSON.stringify(example),
    })
    .then(response => response.json())
    .then((json) => {
      const { example } = this.state
      example.output = json.output
      this.setState({ example, loading: false })
    })
  }

  handleChange(event) {
    const { example } = this.state
    example.input = event.target.value
    this.setState({ example })
  }

  render() {
    const { example, loading } = this.state
    return (
      <tr key={ example.id }>
        <td>
          <Source>{ example.name }</Source>
        </td>
        <td>
          <form onSubmit={ this.handleSubmit.bind(this) }>
            <div className="input-group">
              <input type="text" className="form-control" value={ example.input } onChange={ this.handleChange.bind(this) } />
              <span className="input-group-btn">
                <button className="btn btn-secondary" type="submit">
                  <i className={ `fa fa-fw fa-refresh ${loading ? 'fa-spin' : ''}` }></i>
                </button>
              </span>
            </div>
          </form>
        </td>
        <td>
          <Source>{ this.state.output || example.output }</Source>
        </td>
      </tr>
    )
  }
}

const App = ({ examples }) => (
  <table className="table table-bordered">
    <thead className="thead-inverse">
      <tr>
        <th>Filter</th>
        <th>Input</th>
        <th>Output</th>
      </tr>
    </thead>
    <tbody>
      {examples.map(example =>
        <Example example={ example } />
      )}
    </tbody>
  </table>
)

fetch('/examples')
.then(response => response.json())
.then(json => {
  ReactDOM.render(<App examples={ json }/>, document.getElementById('app'))
})
