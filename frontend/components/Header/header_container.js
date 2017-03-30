import { connect } from 'react-redux';
import Header from './header';
import { openLogin, openSignup, logout } from '../../actions/session_actions';

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser
})

const mapDispatchToProps = (dispatch) => ({
  openLogin: () => dispatch(openLogin()),
  openSignup: () => dispatch(openSignup()),
  logout: () => dispatch(logout())
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Header);
