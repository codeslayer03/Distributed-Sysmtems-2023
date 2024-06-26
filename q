SOCKET(7)                                 Linux Programmer's Manual                                SOCKET(7)

NNAAMMEE
       socket - Linux socket interface

SSYYNNOOPPSSIISS
       ##iinncclluuddee <<ssyyss//ssoocckkeett..hh>>

       _s_o_c_k_f_d == ssoocckkeett((iinntt _s_o_c_k_e_t___f_a_m_i_l_y,, iinntt _s_o_c_k_e_t___t_y_p_e,, iinntt _p_r_o_t_o_c_o_l));;

DDEESSCCRRIIPPTTIIOONN
       This  manual  page  describes  the  Linux networking socket layer user interface.  The BSD compatible
       sockets are the uniform interface between the user process and the network  protocol  stacks  in  the
       kernel.   The  protocol  modules  are  grouped  into  _p_r_o_t_o_c_o_l  _f_a_m_i_l_i_e_s such as AAFF__IINNEETT, AAFF__IIPPXX, and
       AAFF__PPAACCKKEETT, and _s_o_c_k_e_t _t_y_p_e_s such as SSOOCCKK__SSTTRREEAAMM or SSOOCCKK__DDGGRRAAMM.  See ssoocckkeett(2) for more information on
       families and types.

   SSoocckkeett--llaayyeerr ffuunnccttiioonnss
       These functions are used by the user process to send or receive packets and to do other socket opera‐
       tions.  For more information see their respective manual pages.

       ssoocckkeett(2) creates a socket, ccoonnnneecctt(2) connects a socket to a  remote  socket  address,  the  bbiinndd(2)
       function  binds  a  socket to a local socket address, lliisstteenn(2) tells the socket that new connections
       shall be accepted, and aacccceepptt(2) is used to get a new socket with a new incoming connection.  ssoocckkeett‐‐
       ppaaiirr(2)  returns  two  connected  anonymous  sockets  (implemented only for a few local families like
       AAFF__UUNNIIXX)

       sseenndd(2), sseennddttoo(2), and sseennddmmssgg(2) send data over a socket, and rreeccvv(2), rreeccvvffrroomm(2), rreeccvvmmssgg(2)  re‐
       ceive  data from a socket.  ppoollll(2) and sseelleecctt(2) wait for arriving data or a readiness to send data.
       In addition, the standard I/O operations like wwrriittee(2), wwrriitteevv(2), sseennddffiillee(2), rreeaadd(2), and rreeaaddvv(2)
       can be used to read and write data.

       ggeettssoocckknnaammee(2) returns the local socket address and ggeettppeeeerrnnaammee(2) returns the remote socket address.
       ggeettssoocckkoopptt(2) and sseettssoocckkoopptt(2) are used to set or get socket layer or  protocol  options.   iiooccttll(2)
       can be used to set or read some other options.

       cclloossee(2) is used to close a socket.  sshhuuttddoowwnn(2) closes parts of a full-duplex socket connection.

       Seeking, or calling pprreeaadd(2) or ppwwrriittee(2) with a nonzero position is not supported on sockets.

       It  is  possible to do nonblocking I/O on sockets by setting the OO__NNOONNBBLLOOCCKK flag on a socket file de‐
       scriptor using ffccnnttll(2).  Then all operations that would block will (usually) return with EEAAGGAAIINN (op‐
       eration  should  be retried later); ccoonnnneecctt(2) will return EEIINNPPRROOGGRREESSSS error.  The user can then wait
       for various events via ppoollll(2) or sseelleecctt(2).

       ┌────────────────────────────────────────────────────────────────────┐
       │                            I/O events                              │
       ├───────────┬───────────┬────────────────────────────────────────────┤
       │Event      │ Poll flag │ Occurrence                                 │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Read       │ POLLIN    │ New data arrived.                          │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Read       │ POLLIN    │ A connection setup has been completed (for │
       │           │           │ connection-oriented sockets)               │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Read       │ POLLHUP   │ A disconnection request has been initiated │
       │           │           │ by the other end.                          │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Read       │ POLLHUP   │ A connection is broken (only  for  connec‐ │
       │           │           │ tion-oriented protocols).  When the socket │
       │           │           │ is written SSIIGGPPIIPPEE is also sent.           │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Write      │ POLLOUT   │ Socket has enough send  buffer  space  for │
       │           │           │ writing new data.                          │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Read/Write │ POLLIN |  │ An outgoing ccoonnnneecctt(2) finished.           │
       │           │ POLLOUT   │                                            │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Read/Write │ POLLERR   │ An asynchronous error occurred.            │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Read/Write │ POLLHUP   │ The other end has shut down one direction. │
       ├───────────┼───────────┼────────────────────────────────────────────┤
       │Exception  │ POLLPRI   │ Urgent data arrived.  SSIIGGUURRGG is sent then. │
       └───────────┴───────────┴────────────────────────────────────────────┘
       An  alternative to ppoollll(2) and sseelleecctt(2) is to let the kernel inform the application about events via
       a SSIIGGIIOO signal.  For that the OO__AASSYYNNCC flag must be set on a socket file descriptor via ffccnnttll(2) and a
       valid signal handler for SSIIGGIIOO must be installed via ssiiggaaccttiioonn(2).  See the _S_i_g_n_a_l_s discussion below.

   SSoocckkeett aaddddrreessss ssttrruuccttuurreess
       Each socket domain has its own format for socket addresses, with a domain-specific address structure.
       Each of these structures begins with an integer "family" field (typed as _s_a___f_a_m_i_l_y___t) that  indicates
       the  type of the address structure.  This allows the various system calls (e.g., ccoonnnneecctt(2), bbiinndd(2),
       aacccceepptt(2), ggeettssoocckknnaammee(2), ggeettppeeeerrnnaammee(2)), which are generic to all socket domains, to determine the
       domain of a particular socket address.

       To  allow  any  type of socket address to be passed to interfaces in the sockets API, the type _s_t_r_u_c_t
       _s_o_c_k_a_d_d_r is defined.  The purpose of this type is purely to allow casting of  domain-specific  socket
       address types to a "generic" type, so as to avoid compiler warnings about type mismatches in calls to
       the sockets API.

       In addition, the sockets API provides the data type _s_t_r_u_c_t _s_o_c_k_a_d_d_r___s_t_o_r_a_g_e.  This type  is  suitable
       to  accommodate  all  supported  domain-specific socket address structures; it is large enough and is
       aligned properly.  (In particular, it is large enough to hold IPv6 socket addresses.)  The  structure
       includes  the  following  field,  which  can  be used to identify the type of socket address actually
       stored in the structure:

               sa_family_t ss_family;

       The _s_o_c_k_a_d_d_r___s_t_o_r_a_g_e structure is useful in programs that must handle socket addresses in  a  generic
       way (e.g., programs that must deal with both IPv4 and IPv6 socket addresses).

   SSoocckkeett ooppttiioonnss
       The  socket  options  listed below can be set by using sseettssoocckkoopptt(2) and read with ggeettssoocckkoopptt(2) with
       the socket level set to SSOOLL__SSOOCCKKEETT for all sockets.  Unless otherwise noted, _o_p_t_v_a_l is a  pointer  to
       an _i_n_t.

       SSOO__AACCCCEEPPTTCCOONNNN
              Returns  a  value  indicating whether or not this socket has been marked to accept connections
              with lliisstteenn(2).  The value 0 indicates that this is not a listening socket, the value 1  indi‐
              cates that this is a listening socket.  This socket option is read-only.

       SSOO__AATTTTAACCHH__FFIILLTTEERR (since Linux 2.2), SSOO__AATTTTAACCHH__BBPPFF (since Linux 3.19)
              Attach  a  classic  BPF  (SSOO__AATTTTAACCHH__FFIILLTTEERR)  or an extended BPF (SSOO__AATTTTAACCHH__BBPPFF) program to the
              socket for use as a filter of incoming packets.  A packet will be dropped if the  filter  pro‐
              gram  returns  zero.   If  the  filter  program returns a nonzero value which is less than the
              packet's data length, the packet will be truncated to the length returned.  If the  value  re‐
              turned  by  the filter is greater than or equal to the packet's data length, the packet is al‐
              lowed to proceed unmodified.

              The argument for SSOO__AATTTTAACCHH__FFIILLTTEERR is a _s_o_c_k___f_p_r_o_g structure, defined in _<_l_i_n_u_x_/_f_i_l_t_e_r_._h_>:

                  struct sock_fprog {
                      unsigned short      len;
                      struct sock_filter *filter;
                  };

              The argument for SSOO__AATTTTAACCHH__BBPPFF is a file descriptor returned by the  bbppff(2)  system  call  and
              must refer to a program of type BBPPFF__PPRROOGG__TTYYPPEE__SSOOCCKKEETT__FFIILLTTEERR.

              These  options  may be set multiple times for a given socket, each time replacing the previous
              filter program.  The classic and extended versions may be called on the same socket,  but  the
              previous  filter will always be replaced such that a socket never has more than one filter de‐
              fined.

              Both classic and extended BPF are explained in the kernel source  file  _D_o_c_u_m_e_n_t_a_t_i_o_n_/_n_e_t_w_o_r_k_‐
              _i_n_g_/_f_i_l_t_e_r_._t_x_t

       SSOO__AATTTTAACCHH__RREEUUSSEEPPOORRTT__CCBBPPFF, SSOO__AATTTTAACCHH__RREEUUSSEEPPOORRTT__EEBBPPFF
              For  use  with  the  SSOO__RREEUUSSEEPPOORRTT  option,  these  options allow the user to set a classic BPF
              (SSOO__AATTTTAACCHH__RREEUUSSEEPPOORRTT__CCBBPPFF) or an extended BPF (SSOO__AATTTTAACCHH__RREEUUSSEEPPOORRTT__EEBBPPFF) program which defines
              how  packets  are  assigned  to the sockets in the reuseport group (that is, all sockets which
              have SSOO__RREEUUSSEEPPOORRTT set and are using the same local address to receive packets).

              The BPF program must return an index between 0 and N-1 representing the  socket  which  should
              receive  the  packet  (where N is the number of sockets in the group).  If the BPF program re‐
              turns an invalid index, socket selection will fall back to the plain SSOO__RREEUUSSEEPPOORRTT mechanism.

              Sockets are numbered in the order in which they are added to the group (that is, the order  of
              bbiinndd(2)  calls  for UDP sockets or the order of lliisstteenn(2) calls for TCP sockets).  New sockets
              added to a reuseport group will inherit the BPF program.  When a  socket  is  removed  from  a
              reuseport  group  (via  cclloossee(2)),  the last socket in the group will be moved into the closed
              socket's position.

              These options may be set repeatedly at any time on any socket in the group to replace the cur‐
              rent BPF program used by all sockets in the group.

              SSOO__AATTTTAACCHH__RREEUUSSEEPPOORRTT__CCBBPPFF takes the same argument type as SSOO__AATTTTAACCHH__FFIILLTTEERR and SSOO__AATTTTAACCHH__RREEUUSSEE‐‐
              PPOORRTT__EEBBPPFF takes the same argument type as SSOO__AATTTTAACCHH__BBPPFF.

              UDP support for this feature is available since Linux 4.5;  TCP  support  is  available  since
              Linux 4.6.

       SSOO__BBIINNDDTTOODDEEVVIICCEE
              Bind  this  socket  to  a  particular device like “eth0”, as specified in the passed interface
              name.  If the name is an empty string or the option length is zero, the socket device  binding
              is removed.  The passed option is a variable-length null-terminated interface name string with
              the maximum size of IIFFNNAAMMSSIIZZ.  If a socket is bound to an  interface,  only  packets  received
              from  that  particular  interface  are processed by the socket.  Note that this works only for
              some socket types, particularly AAFF__IINNEETT sockets.  It is not supported for packet sockets  (use
              normal bbiinndd(2) there).

              Before Linux 3.8, this socket option could be set, but could not retrieved with ggeettssoocckkoopptt(2).
              Since Linux 3.8, it is readable.  The _o_p_t_l_e_n argument should contain the buffer size available
              to  receive  the  device  name  and is recommended to be IIFFNNAAMMSSIIZZ bytes.  The real device name
              length is reported back in the _o_p_t_l_e_n argument.

       SSOO__BBRROOAADDCCAASSTT
              Set or get the broadcast flag.  When enabled, datagram sockets are allowed to send packets  to
              a broadcast address.  This option has no effect on stream-oriented sockets.

       SSOO__BBSSDDCCOOMMPPAATT
              Enable BSD bug-to-bug compatibility.  This is used by the UDP protocol module in Linux 2.0 and
              2.2.  If enabled, ICMP errors received for a UDP socket will not be passed to  the  user  pro‐
              gram.   In  later  kernel  versions,  support  for  this option has been phased out: Linux 2.4
              silently ignores it, and Linux 2.6 generates a kernel warning (printk())  if  a  program  uses
              this  option.   Linux  2.0  also  enabled  BSD bug-to-bug compatibility options (random header
              changing, skipping of the broadcast flag) for raw sockets with this option, but that  was  re‐
              moved in Linux 2.2.

       SSOO__DDEEBBUUGG
              Enable  socket  debugging.  Allowed only for processes with the CCAAPP__NNEETT__AADDMMIINN capability or an
              effective user ID of 0.

       SSOO__DDEETTAACCHH__FFIILLTTEERR (since Linux 2.2), SSOO__DDEETTAACCHH__BBPPFF (since Linux 3.19)
              These two options, which are synonyms, may be used to remove the classic or extended BPF  pro‐
              gram  attached to a socket with either SSOO__AATTTTAACCHH__FFIILLTTEERR or SSOO__AATTTTAACCHH__BBPPFF.  The option value is
              ignored.

       SSOO__DDOOMMAAIINN (since Linux 2.6.32)
              Retrieves the socket domain as an integer, returning a value such as AAFF__IINNEETT66.  See  ssoocckkeett(2)
              for details.  This socket option is read-only.

       SSOO__EERRRROORR
              Get and clear the pending socket error.  This socket option is read-only.  Expects an integer.

       SSOO__DDOONNTTRROOUUTTEE
              Don't  send  via  a  gateway,  send  only to directly connected hosts.  The same effect can be
              achieved by setting the MMSSGG__DDOONNTTRROOUUTTEE flag on a socket sseenndd(2) operation.  Expects an  integer
              boolean flag.

       SSOO__IINNCCOOMMIINNGG__CCPPUU (gettable since Linux 3.19, settable since Linux 4.4)
              Sets or gets the CPU affinity of a socket.  Expects an integer flag.

                  int cpu = 1;
                  setsockopt(fd, SOL_SOCKET, SO_INCOMING_CPU, &cpu,
                             sizeof(cpu));

              Because all of the packets for a single stream (i.e., all packets for the same 4-tuple) arrive
              on the single RX queue that is associated with a particular CPU, the typical use  case  is  to
              employ  one listening process per RX queue, with the incoming flow being handled by a listener
              on the same CPU that is handling the RX queue.  This provides optimal NUMA behavior and  keeps
              CPU caches hot.

       SSOO__IINNCCOOMMIINNGG__NNAAPPII__IIDD (gettable since Linux 4.12)
              Returns  a  system-level  unique ID called NAPI ID that is associated with a RX queue on which
              the last packet associated with that socket is received.

              This can be used by an application to split the incoming flows among worker threads  based  on
              the  RX  queue  on  which  the packets associated with the flows are received.  It allows each
              worker thread to be associated with a NIC HW receive queue and service all the connection  re‐
              quests  received  on  that  RX  queue.   This  mapping between a app thread and a HW NIC queue
              streamlines the flow of data from the NIC to the application.

       SSOO__KKEEEEPPAALLIIVVEE
              Enable sending of keep-alive messages on  connection-oriented  sockets.   Expects  an  integer
              boolean flag.

       SSOO__LLIINNGGEERR
              Sets or gets the SSOO__LLIINNGGEERR option.  The argument is a _l_i_n_g_e_r structure.

                  struct linger {
                      int l_onoff;    /* linger active */
                      int l_linger;   /* how many seconds to linger for */
                  };

              When  enabled,  a  cclloossee(2)  or  sshhuuttddoowwnn(2) will not return until all queued messages for the
              socket have been successfully sent or the linger timeout has  been  reached.   Otherwise,  the
              call returns immediately and the closing is done in the background.  When the socket is closed
              as part of eexxiitt(2), it always lingers in the background.

       SSOO__LLOOCCKK__FFIILLTTEERR
              When set, this option will prevent changing the filters associated  with  the  socket.   These
              filters  include  any  set  using  the  socket options SSOO__AATTTTAACCHH__FFIILLTTEERR, SSOO__AATTTTAACCHH__BBPPFF, SSOO__AATT‐‐
              TTAACCHH__RREEUUSSEEPPOORRTT__CCBBPPFF, and SSOO__AATTTTAACCHH__RREEUUSSEEPPOORRTT__EEBBPPFF.

              The typical use case is for a privileged process to set up a raw socket (an operation that re‐
              quires the CCAAPP__NNEETT__RRAAWW capability), apply a restrictive filter, set the SSOO__LLOOCCKK__FFIILLTTEERR option,
              and then either drop its privileges or pass the socket  file  descriptor  to  an  unprivileged
              process via a UNIX domain socket.

              Once  the  SSOO__LLOOCCKK__FFIILLTTEERR option has been enabled, attempts to change or remove the filter at‐
              tached to a socket, or to disable the SSOO__LLOOCCKK__FFIILLTTEERR option will fail with the error EEPPEERRMM.

       SSOO__MMAARRKK (since Linux 2.6.25)
              Set the mark for each packet sent through this socket (similar to the  netfilter  MARK  target
              but  socket-based).  Changing the mark can be used for mark-based routing without netfilter or
              for packet filtering.  Setting this option requires the CCAAPP__NNEETT__AADDMMIINN capability.

       SSOO__OOOOBBIINNLLIINNEE
              If this option is enabled, out-of-band data is directly placed into the receive  data  stream.
              Otherwise, out-of-band data is passed only when the MMSSGG__OOOOBB flag is set during receiving.

       SSOO__PPAASSSSCCRREEDD
              Enable  or disable the receiving of the SSCCMM__CCRREEDDEENNTTIIAALLSS control message.  For more information
              see uunniixx(7).

       SSOO__PPAASSSSSSEECC
              Enable or disable the receiving of the SSCCMM__SSEECCUURRIITTYY control message.  For more information see
              uunniixx(7).

       SSOO__PPEEEEKK__OOFFFF (since Linux 3.4)
              This  option,  which  is  currently  supported only for uunniixx(7) sockets, sets the value of the
              "peek offset" for the rreeccvv(2) system call when used with MMSSGG__PPEEEEKK flag.

              When this option is set to a negative value (it is set to -1 for all new sockets), traditional
              behavior  is  provided:  rreeccvv(2)  with  the MMSSGG__PPEEEEKK flag will peek data from the front of the
              queue.

              When the option is set to a value greater than or equal to zero, then the next  peek  at  data
              queued in the socket will occur at the byte offset specified by the option value.  At the same
              time, the "peek offset" will be incremented by the number of bytes that were peeked  from  the
              queue, so that a subsequent peek will return the next data in the queue.

              If  data is removed from the front of the queue via a call to rreeccvv(2) (or similar) without the
              MMSSGG__PPEEEEKK flag, the "peek offset" will be decreased by the number of bytes removed.   In  other
              words, receiving data without the MMSSGG__PPEEEEKK flag will cause the "peek offset" to be adjusted to
              maintain the correct relative position in the queued data, so that a subsequent peek will  re‐
              trieve the data that would have been retrieved had the data not been removed.

              For datagram sockets, if the "peek offset" points to the middle of a packet, the data returned
              will be marked with the MMSSGG__TTRRUUNNCC flag.

              The following example serves to illustrate the use of SSOO__PPEEEEKK__OOFFFF.  Suppose  a  stream  socket
              has the following queued input data:

                  aabbccddeeff

              The following sequence of rreeccvv(2) calls would have the effect noted in the comments:

                  int ov = 4;                  // Set peek offset to 4
                  setsockopt(fd, SOL_SOCKET, SO_PEEK_OFF, &ov, sizeof(ov));

                  recv(fd, buf, 2, MSG_PEEK);  // Peeks "cc"; offset set to 6
                  recv(fd, buf, 2, MSG_PEEK);  // Peeks "dd"; offset set to 8
                  recv(fd, buf, 2, 0);         // Reads "aa"; offset set to 6
                  recv(fd, buf, 2, MSG_PEEK);  // Peeks "ee"; offset set to 8

       SSOO__PPEEEERRCCRREEDD
              Return the credentials of the peer process connected to this socket.  For further details, see
              uunniixx(7).

       SSOO__PPEEEERRSSEECC (since Linux 2.6.2)
              Return the security context of the peer socket connected to this socket.  For further details,
              see uunniixx(7) and iipp(7).

       SSOO__PPRRIIOORRIITTYY
              Set  the protocol-defined priority for all packets to be sent on this socket.  Linux uses this
              value to order the networking queues: packets with a higher priority may  be  processed  first
              depending  on the selected device queueing discipline.  Setting a priority outside the range 0
              to 6 requires the CCAAPP__NNEETT__AADDMMIINN capability.

       SSOO__PPRROOTTOOCCOOLL (since Linux 2.6.32)
              Retrieves the socket protocol as an integer, returning a  value  such  as  IIPPPPRROOTTOO__SSCCTTPP.   See
              ssoocckkeett(2) for details.  This socket option is read-only.

       SSOO__RRCCVVBBUUFF
              Sets  or  gets  the maximum socket receive buffer in bytes.  The kernel doubles this value (to
              allow space for bookkeeping overhead) when it is set using  sseettssoocckkoopptt(2),  and  this  doubled
              value    is    returned    by    ggeettssoocckkoopptt(2).    The   default   value   is   set   by   the
              _/_p_r_o_c_/_s_y_s_/_n_e_t_/_c_o_r_e_/_r_m_e_m___d_e_f_a_u_l_t  file,  and  the  maximum  allowed  value  is   set   by   the
              _/_p_r_o_c_/_s_y_s_/_n_e_t_/_c_o_r_e_/_r_m_e_m___m_a_x file.  The minimum (doubled) value for this option is 256.

       SSOO__RRCCVVBBUUFFFFOORRCCEE (since Linux 2.6.14)
              Using  this  socket  option, a privileged (CCAAPP__NNEETT__AADDMMIINN) process can perform the same task as
              SSOO__RRCCVVBBUUFF, but the _r_m_e_m___m_a_x limit can be overridden.

       SSOO__RRCCVVLLOOWWAATT and SSOO__SSNNDDLLOOWWAATT
              Specify the minimum number of bytes in the buffer until the socket layer will pass the data to
              the  protocol (SSOO__SSNNDDLLOOWWAATT) or the user on receiving (SSOO__RRCCVVLLOOWWAATT).  These two values are ini‐
              tialized to 1.  SSOO__SSNNDDLLOOWWAATT is not changeable on Linux (sseettssoocckkoopptt(2)  fails  with  the  error
              EENNOOPPRROOTTOOOOPPTT).  SSOO__RRCCVVLLOOWWAATT is changeable only since Linux 2.4.

              Before  Linux  2.6.28 sseelleecctt(2), ppoollll(2), and eeppoollll(7) did not respect the SSOO__RRCCVVLLOOWWAATT setting
              on Linux, and indicated a socket as readable when even a single byte of data was available.  A
              subsequent read from the socket would then block until SSOO__RRCCVVLLOOWWAATT bytes are available.  Since
              Linux 2.6.28, sseelleecctt(2), ppoollll(2), and eeppoollll(7) indicate a socket as readable only if at  least
              SSOO__RRCCVVLLOOWWAATT bytes are available.

       SSOO__RRCCVVTTIIMMEEOO and SSOO__SSNNDDTTIIMMEEOO
              Specify  the receiving or sending timeouts until reporting an error.  The argument is a _s_t_r_u_c_t
              _t_i_m_e_v_a_l.  If an input or output function blocks for this period of time,  and  data  has  been
              sent or received, the return value of that function will be the amount of data transferred; if
              no data has been transferred and the timeout has been reached, then -1 is returned with  _e_r_r_n_o
              set to EEAAGGAAIINN or EEWWOOUULLDDBBLLOOCCKK, or EEIINNPPRROOGGRREESSSS (for ccoonnnneecctt(2)) just as if the socket was speci‐
              fied to be nonblocking.  If the timeout is set to zero (the default), then the operation  will
              never  timeout.   Timeouts  only  have  effect for system calls that perform socket I/O (e.g.,
              rreeaadd(2), rreeccvvmmssgg(2), sseenndd(2), sseennddmmssgg(2)); timeouts have no  effect  for  sseelleecctt(2),  ppoollll(2),
              eeppoollll__wwaaiitt(2), and so on.

       SSOO__RREEUUSSEEAADDDDRR
              Indicates  that the rules used in validating addresses supplied in a bbiinndd(2) call should allow
              reuse of local addresses.  For AAFF__IINNEETT sockets this means that a socket may bind, except  when
              there  is an active listening socket bound to the address.  When the listening socket is bound
              to IINNAADDDDRR__AANNYY with a specific port then it is not possible to bind to this port for any  local
              address.  Argument is an integer boolean flag.

       SSOO__RREEUUSSEEPPOORRTT (since Linux 3.9)
              Permits multiple AAFF__IINNEETT or AAFF__IINNEETT66 sockets to be bound to an identical socket address.  This
              option must be set on each socket (including the first socket) prior to calling bbiinndd(2) on the
              socket.  To prevent port hijacking, all of the processes binding to the same address must have
              the same effective UID.  This option can be employed with both TCP and UDP sockets.

              For TCP sockets, this option allows aacccceepptt(2) load distribution in a multi-threaded server  to
              be  improved by using a distinct listener socket for each thread.  This provides improved load
              distribution as compared to traditional techniques such using  a  single  aacccceepptt(2)ing  thread
              that  distributes  connections,  or having multiple threads that compete to aacccceepptt(2) from the
              same socket.

              For UDP sockets, the use of this option can provide better distribution of incoming  datagrams
              to multiple processes (or threads) as compared to the traditional technique of having multiple
              processes compete to receive datagrams on the same socket.

       SSOO__RRXXQQ__OOVVFFLL (since Linux 2.6.33)
              Indicates that an unsigned 32-bit value ancillary message (cmsg) should  be  attached  to  re‐
              ceived skbs indicating the number of packets dropped by the socket since its creation.

       SSOO__SSEELLEECCTT__EERRRR__QQUUEEUUEE (since Linux 3.10)
              When  this  option  is set on a socket, an error condition on a socket causes notification not
              only via the _e_x_c_e_p_t_f_d_s set of sseelleecctt(2).  Similarly, ppoollll(2) also returns a  PPOOLLLLPPRRII  whenever
              an PPOOLLLLEERRRR event is returned.

              Background:  this  option was added when waking up on an error condition occurred only via the
              _r_e_a_d_f_d_s and _w_r_i_t_e_f_d_s sets of sseelleecctt(2).  The option was added to allow  monitoring  for  error
              conditions  via  the _e_x_c_e_p_t_f_d_s argument without simultaneously having to receive notifications
              (via _r_e_a_d_f_d_s) for regular data that can be read from the socket.  After changes in Linux 4.16,
              the use of this flag to achieve the desired notifications is no longer necessary.  This option
              is nevertheless retained for backwards compatibility.

       SSOO__SSNNDDBBUUFF
              Sets or gets the maximum socket send buffer in bytes.  The kernel doubles this value (to allow
              space  for bookkeeping overhead) when it is set using sseettssoocckkoopptt(2), and this doubled value is
              returned by ggeettssoocckkoopptt(2).  The default value is set  by  the  _/_p_r_o_c_/_s_y_s_/_n_e_t_/_c_o_r_e_/_w_m_e_m___d_e_f_a_u_l_t
              file  and the maximum allowed value is set by the _/_p_r_o_c_/_s_y_s_/_n_e_t_/_c_o_r_e_/_w_m_e_m___m_a_x file.  The mini‐
              mum (doubled) value for this option is 2048.

       SSOO__SSNNDDBBUUFFFFOORRCCEE (since Linux 2.6.14)
              Using this socket option, a privileged (CCAAPP__NNEETT__AADDMMIINN) process can perform the  same  task  as
              SSOO__SSNNDDBBUUFF, but the _w_m_e_m___m_a_x limit can be overridden.

       SSOO__TTIIMMEESSTTAAMMPP
              Enable  or  disable  the receiving of the SSOO__TTIIMMEESSTTAAMMPP control message.  The timestamp control
              message is sent with level SSOOLL__SSOOCCKKEETT and a _c_m_s_g___t_y_p_e of SSCCMM__TTIIMMEESSTTAAMMPP.  The  _c_m_s_g___d_a_t_a  field
              is  a  _s_t_r_u_c_t  _t_i_m_e_v_a_l  indicating the reception time of the last packet passed to the user in
              this call.  See ccmmssgg(3) for details on control messages.

       SSOO__TTIIMMEESSTTAAMMPPNNSS (since Linux 2.6.22)
              Enable or disable the receiving of the SSOO__TTIIMMEESSTTAAMMPPNNSS control message.  The timestamp  control
              message is sent with level SSOOLL__SSOOCCKKEETT and a _c_m_s_g___t_y_p_e of SSCCMM__TTIIMMEESSTTAAMMPPNNSS.  The _c_m_s_g___d_a_t_a field
              is a _s_t_r_u_c_t _t_i_m_e_s_p_e_c indicating the reception time of the last packet passed to  the  user  in
              this  call.   The  clock used for the timestamp is CCLLOOCCKK__RREEAALLTTIIMMEE.  See ccmmssgg(3) for details on
              control messages.

              A socket cannot mix SSOO__TTIIMMEESSTTAAMMPP and SSOO__TTIIMMEESSTTAAMMPPNNSS: the two modes are mutually exclusive.

       SSOO__TTYYPPEE
              Gets the socket type as an integer (e.g., SSOOCCKK__SSTTRREEAAMM).  This socket option is read-only.

       SSOO__BBUUSSYY__PPOOLLLL (since Linux 3.11)
              Sets the approximate time in microseconds to busy poll on a blocking receive when there is  no
              data.   Increasing  this  value  requires  CCAAPP__NNEETT__AADDMMIINN.  The default for this option is con‐
              trolled by the _/_p_r_o_c_/_s_y_s_/_n_e_t_/_c_o_r_e_/_b_u_s_y___r_e_a_d file.

              The value in the _/_p_r_o_c_/_s_y_s_/_n_e_t_/_c_o_r_e_/_b_u_s_y___p_o_l_l file determines how long sseelleecctt(2)  and  ppoollll(2)
              will  busy poll when they operate on sockets with SSOO__BBUUSSYY__PPOOLLLL set and no events to report are
              found.

              In both cases, busy polling will only be done when the socket last received data from  a  net‐
              work device that supports this option.

              While  busy polling may improve latency of some applications, care must be taken when using it
              since this will increase both CPU utilization and power usage.

   SSiiggnnaallss
       When writing onto a connection-oriented socket that has been shut down (by the local  or  the  remote
       end)  SSIIGGPPIIPPEE  is sent to the writing process and EEPPIIPPEE is returned.  The signal is not sent when the
       write call specified the MMSSGG__NNOOSSIIGGNNAALL flag.

       When requested with the FFIIOOSSEETTOOWWNN ffccnnttll(2) or SSIIOOCCSSPPGGRRPP iiooccttll(2), SSIIGGIIOO is sent when an I/O event oc‐
       curs.   It is possible to use ppoollll(2) or sseelleecctt(2) in the signal handler to find out which socket the
       event occurred on.  An alternative (in Linux 2.2) is to set a real-time signal using the FF__SSEETTSSIIGG ffcc‐‐
       nnttll(2);  the  handler  of  the  real time signal will be called with the file descriptor in the _s_i___f_d
       field of its _s_i_g_i_n_f_o___t.  See ffccnnttll(2) for more information.

       Under some circumstances (e.g., multiple processes accessing a single  socket),  the  condition  that
       caused  the  SSIIGGIIOO  may have already disappeared when the process reacts to the signal.  If this hap‐
       pens, the process should wait again because Linux will resend the signal later.

   //pprroocc iinntteerrffaacceess
       The core socket networking parameters can be accessed via files in the directory _/_p_r_o_c_/_s_y_s_/_n_e_t_/_c_o_r_e_/.

       _r_m_e_m___d_e_f_a_u_l_t
              contains the default setting in bytes of the socket receive buffer.

       _r_m_e_m___m_a_x
              contains the maximum socket receive buffer size in bytes which a user may  set  by  using  the
              SSOO__RRCCVVBBUUFF socket option.

       _w_m_e_m___d_e_f_a_u_l_t
              contains the default setting in bytes of the socket send buffer.

       _w_m_e_m___m_a_x
              contains  the  maximum  socket  send  buffer  size  in bytes which a user may set by using the
              SSOO__SSNNDDBBUUFF socket option.

       _m_e_s_s_a_g_e___c_o_s_t and _m_e_s_s_a_g_e___b_u_r_s_t
              configure the token bucket filter used to load limit warning messages caused by external  net‐
              work events.

       _n_e_t_d_e_v___m_a_x___b_a_c_k_l_o_g
              Maximum number of packets in the global input queue.

       _o_p_t_m_e_m___m_a_x
              Maximum length of ancillary data and user control data like the iovecs per socket.

   IIooccttllss
       These operations can be accessed using iiooccttll(2):

           _e_r_r_o_r == iiooccttll((_i_p___s_o_c_k_e_t,, _i_o_c_t_l___t_y_p_e,, _&_v_a_l_u_e___r_e_s_u_l_t));;

       SSIIOOCCGGSSTTAAMMPP
              Return  a  _s_t_r_u_c_t  _t_i_m_e_v_a_l  with  the receive timestamp of the last packet passed to the user.
              This is useful for accurate round trip time measurements.  See sseettiittiimmeerr(2) for a  description
              of  _s_t_r_u_c_t  _t_i_m_e_v_a_l.   This  ioctl  should be used only if the socket options SSOO__TTIIMMEESSTTAAMMPP and
              SSOO__TTIIMMEESSTTAAMMPPNNSS are not set on the socket.  Otherwise, it returns the  timestamp  of  the  last
              packet that was received while SSOO__TTIIMMEESSTTAAMMPP and SSOO__TTIIMMEESSTTAAMMPPNNSS were not set, or it fails if no
              such packet has been received, (i.e., iiooccttll(2) returns -1 with _e_r_r_n_o set to EENNOOEENNTT).

       SSIIOOCCSSPPGGRRPP
              Set the process or process group that is to receive SSIIGGIIOO or SSIIGGUURRGG signals when  I/O  becomes
              possible  or urgent data is available.  The argument is a pointer to a _p_i_d___t.  For further de‐
              tails, see the description of FF__SSEETTOOWWNN in ffccnnttll(2).

       FFIIOOAASSYYNNCC
              Change the OO__AASSYYNNCC flag to enable or disable asynchronous I/O mode of the  socket.   Asynchro‐
              nous I/O mode means that the SSIIGGIIOO signal or the signal set with FF__SSEETTSSIIGG is raised when a new
              I/O event occurs.

              Argument is an integer boolean flag.  (This operation is synonymous with the use  of  ffccnnttll(2)
              to set the OO__AASSYYNNCC flag.)

       SSIIOOCCGGPPGGRRPP
              Get the current process or process group that receives SSIIGGIIOO or SSIIGGUURRGG signals, or 0 when none
              is set.

       Valid ffccnnttll(2) operations:

       FFIIOOGGEETTOOWWNN
              The same as the SSIIOOCCGGPPGGRRPP iiooccttll(2).

       FFIIOOSSEETTOOWWNN
              The same as the SSIIOOCCSSPPGGRRPP iiooccttll(2).

VVEERRSSIIOONNSS
       SSOO__BBIINNDDTTOODDEEVVIICCEE was introduced in Linux 2.0.30.  SSOO__PPAASSSSCCRREEDD is new in Linux 2.2.  The  _/_p_r_o_c  inter‐
       faces  were  introduced  in Linux 2.2.  SSOO__RRCCVVTTIIMMEEOO and SSOO__SSNNDDTTIIMMEEOO are supported since Linux 2.3.41.
       Earlier, timeouts were fixed to a protocol-specific setting, and could not be read or written.

NNOOTTEESS
       Linux assumes that half of the send/receive buffer is used for internal kernel structures;  thus  the
       values in the corresponding _/_p_r_o_c files are twice what can be observed on the wire.

       Linux  will  allow  port reuse only with the SSOO__RREEUUSSEEAADDDDRR option when this option was set both in the
       previous program that performed a bbiinndd(2) to the port and in the program  that  wants  to  reuse  the
       port.   This  differs from some implementations (e.g., FreeBSD) where only the later program needs to
       set the SSOO__RREEUUSSEEAADDDDRR option.  Typically this difference is invisible, since, for  example,  a  server
       program is designed to always set this option.

SSEEEE AALLSSOO
       wwiirreesshhaarrkk(1),  bbppff(2),  ccoonnnneecctt(2),  ggeettssoocckkoopptt(2),  sseettssoocckkoopptt(2), ssoocckkeett(2), ppccaapp(3), aaddddrreessss__ffaammii‐‐
       lliieess(7), ccaappaabbiilliittiieess(7), ddddpp(7), iipp(7), iippvv66(7), ppaacckkeett(7), ttccpp(7), uuddpp(7), uunniixx(7), ttccppdduummpp(8)

CCOOLLOOPPHHOONN
       This page is part of release 5.10 of the Linux _m_a_n_-_p_a_g_e_s project.  A description of the project,  in‐
       formation   about   reporting   bugs,  and  the  latest  version  of  this  page,  can  be  found  at
       https://www.kernel.org/doc/man-pages/.

Linux                                            2020-08-13                                        SOCKET(7)
